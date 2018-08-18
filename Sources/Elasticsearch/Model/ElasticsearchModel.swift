import HTTP
import Crypto

public protocol ElasticsearchModel: Provider, Codable {
    static var keyEncodingStratagey: JSONEncoder.KeyEncodingStrategy? { get }
    static var keyDecodingStratagey: JSONDecoder.KeyDecodingStrategy? { get }
    static var dateEncodingStratagey: JSONEncoder.DateEncodingStrategy? { get }
    static var dateDecodingStratagey: JSONDecoder.DateDecodingStrategy? { get }
    
    var _indexName: String { get }
    var _typeName: String { get }
    
    static func tuneConfiguration(key: String, config: inout Mappable)
}

extension ElasticsearchModel {
    public static var keyEncodingStratagey: JSONEncoder.KeyEncodingStrategy? {
        return nil
    }
    public static var keyDecodingStratagey: JSONDecoder.KeyDecodingStrategy? {
        return nil
    }
    public static var dateEncodingStratagey: JSONEncoder.DateEncodingStrategy? {
        return .millisecondsSince1970
    }
    public static var dateDecodingStratagey: JSONDecoder.DateDecodingStrategy? {
        return .millisecondsSince1970
    }
    
    public var _typeName: String {
        return "_doc"
    }
    
    public static func tuneConfiguration(key: String, config: inout Mappable) {
    }

    public func register(_ services: inout Services) throws {
    }
    
    public func willBoot(_ container: Container) throws -> Future<Void> {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
        let config = try container.make(ElasticsearchClientConfig.self)
        return ElasticsearchClient.connect(config: config, on: group).flatMap(to: Void.self) { client in
            return client.fetchIndex(name: self._indexName).flatMap { index -> Future<Void> in
                if index != nil {
                    client.logger?.record(query: self._indexName + " index exists")
                    return .done(on: container)
                }
                
                let body = try self.generateIndexJSON()
                return client.send(HTTPMethod.PUT, to: "/\(self._indexName)", with: body).map { response -> Void in
                    return
                }
            }
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    func generateIndexJSON() throws -> Data {
        let builder = ElasticsearchIndexBuilder(indexName: _indexName)
        
        let reserved = ["_indexName", "_typeName"]
        
        let mirror = Mirror(reflecting: self)
        for case let (keyName?, value) in mirror.children {
            if reserved.contains(keyName) {
                continue
            }
            
            var esType: Mappable? = nil
            switch type(of: value) {
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
                type(of: self).tuneConfiguration(key: keyName, config: &esType)
                builder.property(key: keyName, type: esType)
            }
        }
        
        let propertiesJSON = try JSONEncoder().encode(builder.mapping.doc.properties.mapValues { AnyMap($0) })
        let digest = try SHA1.hash(propertiesJSON)
        if let _ = builder.mapping.doc.meta {
            builder.mapping.doc.meta!.private.propertiesHash = digest.hexEncodedString()
        }
        
        let encoder = JSONEncoder()
        if let strategy = type(of: self).keyEncodingStratagey {
            encoder.keyEncodingStrategy = strategy
        }
        return try encoder.encode(builder)
    }
}
