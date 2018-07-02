import HTTP
import Crypto

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

internal struct IndexMeta: Codable {
    var `private`: PrivateIndexMeta
    var userDefined: [String: String]?
    
    init() {
        self.private = PrivateIndexMeta(version: 1)
    }
}

public struct PrivateIndexMeta: Codable {
    let serialVersion: Int
    var propertiesHash: String
    
    init(version: Int) {
        self.serialVersion = version
        self.propertiesHash = ""
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
        var doc: DocumentTypeSettings
        
        enum CodingKeys: String, CodingKey {
            case doc = "_doc"
        }
    }
    
    struct DocumentTypeSettings: Codable {
        var properties = [String: AnyMap]()
        var enabled = true
        var dynamic = false
        var meta: IndexMeta
        
        enum CodingKeys: String, CodingKey {
            case properties
            case enabled
            case dynamic
            case meta = "_meta"
        }
        
        init() {
            self.meta = IndexMeta()
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.properties = try container.decode([String: AnyMap].self, forKey: .properties)
            self.meta = try container.decode(IndexMeta.self, forKey: .meta)

            if container.contains(.enabled) {
                do {
                    self.enabled = (try container.decode(Bool.self, forKey: .enabled))
                }
                catch {
                    self.enabled = try container.decode(String.self, forKey: .enabled) == "true"
                }
            }
            if container.contains(.dynamic) {
                do {
                    self.dynamic = (try container.decode(Bool.self, forKey: .dynamic))
                }
                catch {
                    self.dynamic = try container.decode(String.self, forKey: .dynamic) == "true"
                }
            }
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
    
    func settings(index: IndexSettings) -> Self {
        if self.settings == nil {
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
    
    func add(metaKey: String, metaValue: String) -> Self {
        if mappings.doc.meta.userDefined == nil {
            mappings.doc.meta.userDefined = [String: String]()
        }
        mappings.doc.meta.userDefined![metaKey] = metaValue
        return self
    }
    
    func create() throws -> Future<Void> {
        guard let name = indexName else {
            throw ElasticsearchError(identifier: "missing_indexName", reason: "Missing index name for index creation", source: .capture())
        }
        guard let _ = self.client else {
            throw ElasticsearchError(identifier: "missing_client", reason: "Missing client for index creation", source: .capture())
        }
        
        let propertiesJSON = try JSONEncoder().encode(self.mappings.doc.properties)
        let digest = try SHA1.hash(propertiesJSON)
        self.mappings.doc.meta.private.propertiesHash = digest.hexEncodedString()
        
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
