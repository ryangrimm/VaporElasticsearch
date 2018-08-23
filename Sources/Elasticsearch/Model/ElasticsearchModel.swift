import Crypto
import HTTP

public typealias ElasticsearchModel = ElasticsearchBaseModel & Reflectable

public protocol ElasticsearchBaseModel: Codable, ModelReflection  {
    static var allowDynamicKeys: Bool { get }
    static var enableSearching: Bool { get }
    
    static var dateEncodingStratagey: JSONEncoder.DateEncodingStrategy? { get }
    static var dateDecodingStratagey: JSONDecoder.DateDecodingStrategy? { get }
    
    static var indexName: String { get }
    static var typeName: String { get }
}

extension ElasticsearchBaseModel {
    public static var allowDynamicKeys: Bool {
        return false
    }
    
    public static var enableSearching: Bool {
        return true
    }
    
    public static var dateEncodingStratagey: JSONEncoder.DateEncodingStrategy? {
        return .millisecondsSince1970
    }
    public static var dateDecodingStratagey: JSONDecoder.DateDecodingStrategy? {
        return .millisecondsSince1970
    }
    
    public static var typeName: String {
        return "_doc"
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
            
            let builder = ElasticsearchIndexBuilder(indexName: Self.indexName, dynamicMapping: self.allowDynamicKeys, enableQuerying: self.enableSearching)

            for (key, var esType) in try self.generateIndexJSON() {
                self.tuneConfiguration(key: key, config: &esType)
                builder.property(key: key, type: esType)
            }
            
            let propertiesJSON = try JSONEncoder().encode(builder.mapping.doc.properties.mapValues { AnyMappable($0) })
            let digest = try SHA1.hash(propertiesJSON)
            if let _ = builder.mapping.doc.meta {
                builder.mapping.doc.meta!.private.propertiesHash = digest.hexEncodedString()
            }
            
            let body = try JSONEncoder().encode(builder)
            return client.send(HTTPMethod.PUT, to: "/\(self.indexName)", with: body).map { response -> Void in
                return
            }
        }
    }
}
