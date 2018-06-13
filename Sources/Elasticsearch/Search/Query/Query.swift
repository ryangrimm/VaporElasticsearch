import Foundation

public protocol QueryElement: Codable {
    static var typeKey: QueryElementMap { get }

    var codingKey: String { get set }
}

public struct Query: Codable {
    let query: QueryElement

    enum CodingKeys: String, CodingKey {
        case query
    }
    
    public init(_ query: QueryElement) {
        self.query = query
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: query.codingKey)!)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        let type = QueryElementMap(rawValue: key!.stringValue)!
//        let type = try container.decode(QueryElementMap.self, forKey: key!)
//        self.query = container.decode(type.metatype, forKey: key)
//        let valueContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: key!)
//        self.query = try valueContainer.decode(type.metatype.self, forKey: .query)
        let foo = try container.superDecoder(forKey: key!)
//        let bar = try foo.container(keyedBy: DynamicKey.self)
        self.query = try type.metatype.init(from: foo)

//        self.query = try valueContainer.superDecoder(forKey: .query)

//        self.query = try type.metatype.init(from: decoder)
    }
}
