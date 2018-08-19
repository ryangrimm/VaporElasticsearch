import Crypto
import HTTP

public protocol ElasticsearchModel: Codable, AnyReflectable  {
    static var dateEncodingStratagey: JSONEncoder.DateEncodingStrategy? { get }
    static var dateDecodingStratagey: JSONDecoder.DateDecodingStrategy? { get }
    
    static var indexName: String { get }
    static var typeName: String { get }
    static var allowDynamicKeys: Bool { get }
    static var enableSearching: Bool { get }
    
    static func tuneConfiguration(key: String, config: inout Mappable)
}

extension ElasticsearchModel {
    public static var dateEncodingStratagey: JSONEncoder.DateEncodingStrategy? {
        return .millisecondsSince1970
    }
    public static var dateDecodingStratagey: JSONDecoder.DateDecodingStrategy? {
        return .millisecondsSince1970
    }
    
    public static var typeName: String {
        return "_doc"
    }
    
    public static var allowDynamicKeys: Bool {
        return false
    }
    
    public static var enableSearching: Bool {
        return true
    }
    
    public static func tuneConfiguration(key: String, config: inout Mappable) {
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    public static func updateIndexMapping(client: ElasticsearchClient) -> Future<Void> {
        return client.fetchIndex(name: self.indexName).flatMap { index -> Future<Void> in
            if index != nil {
                client.logger?.record(query: self.indexName + " index exists")
                return .done(on: client.worker)
            }
            
            let body = try self.generateIndexJSON()
            return client.send(HTTPMethod.PUT, to: "/\(self.indexName)", with: body).map { response -> Void in
                return
            }
        }
    }
    
    static func generateIndexJSON() throws -> Data {
        let builder = ElasticsearchIndexBuilder(indexName: indexName, dynamicMapping: self.allowDynamicKeys, enableQuerying: self.enableSearching)
        
        for property in try self.reflectProperties(depth: 0) {
            var esType: Mappable? = nil
            switch property.type {
            case is ModelBinary?.Type, is ModelBinary.Type, is [ModelBinary].Type, is [ModelBinary]?.Type:
                esType = ModelBinary.Mapping()
            case is ModelBool?.Type, is ModelBool.Type, is [ModelBool].Type, is [ModelBool]?.Type:
                esType = ModelBool.Mapping()
            case is ModelByte?.Type, is ModelByte.Type, is [ModelByte].Type, is [ModelByte]?.Type:
                esType = ModelByte.Mapping()
            case is ModelCompletionSuggester?.Type, is ModelCompletionSuggester.Type, is [ModelCompletionSuggester].Type, is [ModelCompletionSuggester]?.Type:
                esType = ModelCompletionSuggester.Mapping()
            case is ModelDate?.Type, is ModelDate.Type, is [ModelDate].Type, is [ModelDate]?.Type:
                esType = ModelDate.Mapping()
            case is ModelDateRange?.Type, is ModelDateRange.Type, is [ModelDateRange].Type, is [ModelDateRange]?.Type:
                esType = ModelDateRange.Mapping()
            case is ModelDouble?.Type, is ModelDouble.Type, is [ModelDouble].Type, is [ModelDouble]?.Type:
                esType = ModelDouble.Mapping()
            case is ModelDoubleRange?.Type, is ModelDoubleRange.Type, is [ModelDoubleRange].Type, is [ModelDoubleRange]?.Type:
                esType = ModelDoubleRange.Mapping()
            case is ModelFloat?.Type, is ModelFloat.Type, is [ModelFloat].Type, is [ModelFloat]?.Type:
                esType = ModelFloat.Mapping()
            case is ModelFloatRange?.Type, is ModelFloatRange.Type, is [ModelFloatRange].Type, is [ModelFloatRange]?.Type:
                esType = ModelFloatRange.Mapping()
            case is ModelGeoPoint?.Type, is ModelGeoPoint.Type, is [ModelGeoPoint].Type, is [ModelGeoPoint]?.Type:
                esType = ModelGeoPoint.Mapping()
            case is ModelGeoShape?.Type, is ModelGeoShape.Type, is [ModelGeoShape].Type, is [ModelGeoShape]?.Type:
                esType = ModelGeoShape.Mapping()
            case is ModelIPAddress?.Type, is ModelIPAddress.Type, is [ModelIPAddress].Type, is [ModelIPAddress]?.Type:
                esType = ModelIPAddress.Mapping()
            case is ModelInteger?.Type, is ModelInteger.Type, is [ModelInteger].Type, is [ModelInteger]?.Type:
                esType = ModelInteger.Mapping()
            case is ModelIntegerRange?.Type, is ModelIntegerRange.Type, is [ModelIntegerRange].Type, is [ModelIntegerRange]?.Type:
                esType = ModelIntegerRange.Mapping()
            case is ModelJoin?.Type, is ModelJoin.Type, is [ModelJoin].Type, is [ModelJoin]?.Type:
                esType = ModelJoin.Mapping()
            case is ModelKeyword?.Type, is ModelKeyword.Type, is [ModelKeyword].Type, is [ModelKeyword]?.Type:
                esType = ModelKeyword.Mapping()
            case is ModelLong?.Type, is ModelLong.Type, is [ModelLong].Type, is [ModelLong]?.Type:
                esType = ModelLong.Mapping()
            case is ModelLongRange?.Type, is ModelLongRange.Type, is [ModelLongRange].Type, is [ModelLongRange]?.Type:
                esType = ModelLongRange.Mapping()
            case is ModelPercolator?.Type, is ModelPercolator.Type, is [ModelPercolator].Type, is [ModelPercolator]?.Type:
                esType = ModelPercolator.Mapping()
            case is ModelShort?.Type, is ModelShort.Type, is [ModelShort].Type, is [ModelShort]?.Type:
                esType = ModelShort.Mapping()
            case is ModelText?.Type, is ModelText.Type, is [ModelText].Type, is [ModelText]?.Type:
                esType = ModelText.Mapping()
            case is ModelTokenCount?.Type, is ModelTokenCount.Type, is [ModelTokenCount].Type, is [ModelTokenCount]?.Type:
                esType = ModelTokenCount.Mapping()
            default:
                break
            }
            
            if var esType = esType {
                self.tuneConfiguration(key: property.path.first!, config: &esType)
                builder.property(key: property.path.first!, type: esType)
            }
        }
        
        let propertiesJSON = try JSONEncoder().encode(builder.mapping.doc.properties.mapValues { AnyMap($0) })
        let digest = try SHA1.hash(propertiesJSON)
        if let _ = builder.mapping.doc.meta {
            builder.mapping.doc.meta!.private.propertiesHash = digest.hexEncodedString()
        }
        
        let encoder = JSONEncoder()
        return try encoder.encode(builder)
    }
}
