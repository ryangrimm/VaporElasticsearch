import HTTP

public struct ElasticsearchIndexSettings: Codable {
    let numberOfShards: Int
    let numberOfReplicas: Int
    
    enum CodingKeys: String, CodingKey {
        case numberOfShards = "number_of_shards"
        case numberOfReplicas = "number_of_replicas"
    }
    
    init(shards: Int, replicas: Int) {
        numberOfShards = shards
        numberOfReplicas = replicas
    }
}

public class ElasticsearchMapping: Codable {
    
    struct Mappings: Codable {
        var _doc: Properties
    }
    
    struct Properties: Codable {
        var properties: [String: ElasticsearchType]
    }
    
    struct Alias: Codable {
        var routing: String?
    }
    
    var indexName: String? = nil
    var mappings = Mappings(_doc: Properties(properties: [String : ElasticsearchType]()))
    var aliases = [String: Alias]()
    var settings: ElasticsearchIndexSettings? = nil

    enum CodingKeys: String, CodingKey {
        case mappings
        case aliases
        case settings
    }
    
    init(indexName: String) {
        self.indexName = indexName
    }
    
    func settings(index: ElasticsearchIndexSettings) -> Self {
        self.settings = index
        return self
    }
    
    func alias(name: String, routing: String? = nil) -> Self {
        let alias = Alias(routing: routing)
        aliases[name] = alias
        return self
    }
    
    func property(key: String, type: ElasticsearchType) -> Self {
        mappings._doc.properties[key] = type
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
