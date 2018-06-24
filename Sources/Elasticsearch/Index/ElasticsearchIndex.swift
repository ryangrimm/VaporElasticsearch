import HTTP

public struct IndexSettings: Codable {
    let numberOfShards: Int
    let numberOfReplicas: Int
    var creationDate: String? = nil
    var uuid: String? = nil
    var version: Version? = nil
    var providedName: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case numberOfShards = "number_of_shards"
        case numberOfReplicas = "number_of_replicas"
        case creationDate = "creation_date"
        case uuid
        case version
        case providedName = "provided_name"
    }
    
    init(shards: Int, replicas: Int) {
        numberOfShards = shards
        numberOfReplicas = replicas
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        numberOfShards = Int(try container.decode(String.self, forKey: .numberOfShards))!
        numberOfReplicas = Int(try container.decode(String.self, forKey: .numberOfReplicas))!
        creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        version = try container.decodeIfPresent(Version.self, forKey: .version)
        providedName = try container.decodeIfPresent(String.self, forKey: .providedName)
    }
    
    public struct Version: Codable {
        let created: String
    }
}

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
        var doc: Properties
        
        enum CodingKeys: String, CodingKey {
            case doc = "_doc"
        }
    }
    
    struct Properties: Codable {
        var properties: [String: AnyMap]
    }
    
    struct Alias: Codable {
        var routing: String?
    }
    
    var client: ElasticsearchClient? = nil
    var indexName: String? = nil
    var mappings = DefaultType(doc: Properties(properties: [String : AnyMap]()))
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
    
    internal init(indexName: String, client: ElasticsearchClient) {
        self.indexName = indexName
        self.client = client
    }
    
    func settings(index: IndexSettings) -> Self {
        if (self.settings == nil) {
            self.settings = Settings()
        }
        
        self.settings!.index = index
        return self
    }
    
    func alias(name: String, routing: String? = nil) -> Self {
        let alias = Alias(routing: routing)
        aliases[name] = alias
        return self
    }
    
    func property(key: String, type: Mappable) -> Self {
        mappings.doc.properties[key] = AnyMap(type)
        return self
    }
    
    func create() throws -> Future<Void> {
        guard let name = indexName else {
            throw ElasticsearchError(identifier: "missing_indexName", reason: "Missing index name for index creation", source: .capture())
        }
        guard let _ = self.client else {
            throw ElasticsearchError(identifier: "missing_client", reason: "Missing client for index creation", source: .capture())
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
    }
}
