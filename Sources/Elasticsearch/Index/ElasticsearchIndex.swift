import HTTP
import Crypto

public class ElasticsearchIndex: Codable {
    
    struct FetchWrapper: Codable {
        var indexName: String
        var indexMappingValue: ElasticsearchIndex
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: DynamicKey.self)
            try container.encode(indexMappingValue, forKey: DynamicKey(stringValue: indexName)!)
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicKey.self)

            let key = container.allKeys.first!
            indexName = key.stringValue
            indexMappingValue = try container.decode(ElasticsearchIndex.self, forKey: key)
        }
    }
    
    struct DefaultType: Codable {
        var doc: DocumentTypeSettings
        
        enum CodingKeys: String, CodingKey {
            case doc = "_doc"
        }
    }
    
    struct Alias: Codable {
        var routing: String?
    }
    
    var client: ElasticsearchClient? = nil
    var indexName: String? = nil
    var mappings = DefaultType(doc: DocumentTypeSettings())
    var aliases = [String: Alias]()
    var settings: Settings? = nil

    enum CodingKeys: String, CodingKey {
        case mappings
        case aliases
        case settings
    }
    
    internal static func fetch(indexName: String, client: ElasticsearchClient) throws -> Future<ElasticsearchIndex> {
        return try client.send(HTTPMethod.GET, to: "/\(indexName)").map(to: ElasticsearchIndex.self) { response in
            let wrapper = try JSONDecoder().decode(FetchWrapper.self, from: response)
            wrapper.indexMappingValue.indexName = wrapper.indexName
            return wrapper.indexMappingValue
        }
    }
    
    internal init(indexName: String, client: ElasticsearchClient, dynamicMapping: Bool = false, enableQuerying: Bool = true) {
        self.indexName = indexName
        self.client = client
        self.mappings.doc.enabled = enableQuerying
        self.mappings.doc.dynamic = dynamicMapping
    }
    
    public func settings(index: IndexSettings) -> Self {
        if self.settings == nil {
            self.settings = Settings()
        }
        
        self.settings!.index = index
        return self
    }
    
    public func alias(name: String, routing: String? = nil) -> Self {
        let alias = Alias(routing: routing)
        aliases[name] = alias
        return self
    }
    
    public func property(key: String, type: Mappable) -> Self {
        mappings.doc.properties[key] = AnyMap(type)
        return self
    }
    
    public func add(metaKey: String, metaValue: String) -> Self {
        if let meta = mappings.doc.meta, meta.userDefined == nil {
            mappings.doc.meta!.userDefined = [String: String]()
        }
        mappings.doc.meta!.userDefined![metaKey] = metaValue
        return self
    }
    
    public func create() throws -> Future<Void> {
        guard let name = indexName else {
            throw ElasticsearchError(identifier: "missing_indexName", reason: "Missing index name for index creation", source: .capture())
        }
        guard let _ = self.client else {
            throw ElasticsearchError(identifier: "missing_client", reason: "Missing client for index creation", source: .capture())
        }
        
        let propertiesJSON = try JSONEncoder().encode(self.mappings.doc.properties)
        let digest = try SHA1.hash(propertiesJSON)
        if let _ = self.mappings.doc.meta {
            self.mappings.doc.meta!.private.propertiesHash = digest.hexEncodedString()
        }
        
        let body = try JSONEncoder().encode(self)
        return try self.client!.send(HTTPMethod.PUT, to: "/\(name)", with: body).map(to: Void.self) { response in
        }
    }
    
    // TODO - should add an option to ignore if index isn't present
    internal static func delete(indexName: String, client: ElasticsearchClient) throws -> Future<Void> {
        return try client.send(HTTPMethod.DELETE, to: "/\(indexName)").map(to: Void.self) { response in
        }
    }
    
    public struct Settings: Codable {
        var index: IndexSettings?
        var analysis: Analysis? = nil
    }
}
