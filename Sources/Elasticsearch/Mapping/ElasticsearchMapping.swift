import HTTP

public struct ElasticsearchIndexSettings: Codable {
    var index: ElasticsearchIndexSettingsIndex?
}

public struct ElasticsearchIndexVersion: Codable {
    let created: String
}

public struct ElasticsearchIndexSettingsIndex: Codable {
    struct IndexVersion {
        
    }
    
    let numberOfShards: Int
    let numberOfReplicas: Int
    var creationDate: String? = nil
    var uuid: String? = nil
    var version: ElasticsearchIndexVersion? = nil
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
        version = try container.decodeIfPresent(ElasticsearchIndexVersion.self, forKey: .version)
        providedName = try container.decodeIfPresent(String.self, forKey: .providedName)
    }
}

public class ElasticsearchMapping: Codable {
    
    struct FetchWrapper: Codable {
        var indexName: String
        var indexMappingValue: ElasticsearchMapping
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: DynamicKey.self)
            try container.encode(indexMappingValue, forKey: DynamicKey(stringValue: indexName)!)
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicKey.self)

            let key = container.allKeys.first!
            indexName = key.stringValue
            indexMappingValue = try container.decode(ElasticsearchMapping.self, forKey: key)
        }
    }
    
    struct DefaultType: Codable {
        var doc: Properties
        
        enum CodingKeys: String, CodingKey {
            case doc = "_doc"
        }
    }
    
    struct Properties: Codable {
        var properties: [String: ElasticsearchType]
    }
    
    struct Alias: Codable {
        var routing: String?
    }
    
    var indexName: String? = nil
    var mappings = DefaultType(doc: Properties(properties: [String : ElasticsearchType]()))
    var aliases = [String: Alias]()
    var settings: ElasticsearchIndexSettings? = nil

    enum CodingKeys: String, CodingKey {
        case mappings
        case aliases
        case settings
    }
    
    static func fetch(indexName: String, client: ElasticsearchClient) throws -> Future<ElasticsearchMapping> {
        return try client.send(HTTPMethod.GET, to: "/\(indexName)").map(to: ElasticsearchMapping.self) { response in
            let wrapper = try JSONDecoder().decode(FetchWrapper.self, from: response)
            wrapper.indexMappingValue.indexName = wrapper.indexName
            return wrapper.indexMappingValue
        }
    }
    
    init(indexName: String) {
        self.indexName = indexName
    }
    
    func settings(index: ElasticsearchIndexSettingsIndex) -> Self {
        if (self.settings == nil) {
            self.settings = ElasticsearchIndexSettings()
        }
        
        self.settings!.index = index
        return self
    }
    
    func alias(name: String, routing: String? = nil) -> Self {
        let alias = Alias(routing: routing)
        aliases[name] = alias
        return self
    }
    
    func property(key: String, type: ElasticsearchType) -> Self {
        mappings.doc.properties[key] = type
        return self
    }
    
    func create(client: ElasticsearchClient) throws -> Future<Void> {
        guard let name = indexName else {
            throw ElasticsearchError(identifier: "missing_indexName", reason: "Missing index name for index creation", source: .capture())
        }
        
        let body = try JSONEncoder().encode(self)
        return try client.send(HTTPMethod.PUT, to: "/\(name)", with: body).map(to: Void.self) { response in
        }
    }
    
    // XXX - should add an option to ignore if index isn't present
    static func delete(indexName: String, client: ElasticsearchClient) throws -> Future<Void> {
        return try client.send(HTTPMethod.DELETE, to: "/\(indexName)").map(to: Void.self) { response in
        }
    }
}
