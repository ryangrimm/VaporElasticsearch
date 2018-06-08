import HTTP

public class ElasticsearchMapping {
    let indexName: String
    var alias: String?
    var properties = [String: AnyPropertyType]()
    
    static func setup() {
        AnyPropertyType.register(ESTypeText.self)
        AnyPropertyType.register(ESTypeKeyword.self)
        AnyPropertyType.register(ESTypeLong.self)
        AnyPropertyType.register(ESTypeInteger.self)
        AnyPropertyType.register(ESTypeShort.self)
        AnyPropertyType.register(ESTypeByte.self)
        AnyPropertyType.register(ESTypeDouble.self)
        AnyPropertyType.register(ESTypeFloat.self)
        AnyPropertyType.register(ESTypeHalfFloat.self)
        AnyPropertyType.register(ESTypeScaledFloat.self)
//        AnyPropertyType.register(ESTypeDate.self)
//        AnyPropertyType.register(ESTypeBoolean.self)
//        AnyPropertyType.register(ESTypeBinary.self)
//        AnyPropertyType.register(ESTypeIntegerRange.self)
//        AnyPropertyType.register(ESTypeFloatRange.self)
//        AnyPropertyType.register(ESTypeLongRange.self)
//        AnyPropertyType.register(ESTypeDoubleRange.self)
//        AnyPropertyType.register(ESTypeDateRange.self)
//        AnyPropertyType.register(ESTypeArray.self)
//        AnyPropertyType.register(ESTypeObject.self)
//        AnyPropertyType.register(ESTypeNested.self)
//        AnyPropertyType.register(ESTypeGeoPoint.self)
//        AnyPropertyType.register(ESTypeGeoShape.self)
//        AnyPropertyType.register(ESTypeIPAddress.self)
    }
    
    init(indexName: String, alias: String? = nil) {
        self.indexName = indexName
        self.alias = alias
    }
    
    func property(key: String, type: ElasticsearchType) -> Self {
        properties[key] = AnyPropertyType(type)
        return self
    }
    
    func create(client: ElasticsearchClient) throws -> Future<Void> {
        // XXX - These bits in here are hacky, will clean up later

        var jsonProperties = [String: Any]()
        for (key, property) in properties {
            let propertyAsData = try JSONEncoder().encode(property)
            let tempHack = try JSONSerialization.jsonObject(with: propertyAsData, options: []) as? [String: Any]
            jsonProperties[key] = tempHack?["property"]
        }
        
        
        let body: [String: Any] = ["mappings": ["_doc": ["properties": jsonProperties]]]
        print(body)
        
        return try client.send(HTTPMethod.PUT, to: "/\(indexName)", with: body).map(to: Void.self) { response in
            
        }
    }
    
    // XXX - should add an option to ignore if index isn't present
    static func delete(indexName: String, client: ElasticsearchClient) throws -> Future<Void> {
        return try client.send(HTTPMethod.DELETE, to: "/\(indexName)").map(to: Void.self) { response in
        }
    }
}

struct AnyPropertyType: Codable {
    let propertyType: String
    let property: Any?
    
    // Bits needed for the type erasure
    private typealias AnyPropertyTypeDecoder = (KeyedDecodingContainer<CodingKeys>) throws -> Any
    private typealias AnyPropertyTypeEncoder = (Any, inout KeyedEncodingContainer<CodingKeys>) throws -> Void
    
    private static var decoders: [String: AnyPropertyTypeDecoder] = [:]
    private static var encoders: [String: AnyPropertyTypeEncoder] = [:]
    
    static func register<A: Codable>(_ type: A.Type) {
        let typeName = String(describing: type)
        decoders[typeName] = { container in
            try container.decode(A.self, forKey: .property)
        }
        encoders[typeName] = { payload, container in
            try container.encode(payload as! A, forKey: .property)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case propertyType
        case property
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        propertyType = try container.decode(String.self, forKey: .propertyType)
        if let decode = AnyPropertyType.decoders[propertyType] {
            property = try decode(container)
        }
        else {
            property = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let property = self.property {
            guard let encode = AnyPropertyType.encoders[propertyType] else {
                let context = EncodingError.Context(codingPath: [], debugDescription: "Invalid property type: \(propertyType).")
                throw EncodingError.invalidValue(self, context)
            }
            try encode(property, &container)
        } else {
            try container.encodeNil(forKey: .property)
        }
    }
    
    init(_ property: ElasticsearchType) {
        self.propertyType = String(describing: type(of: property))
        self.property = property
    }
}
