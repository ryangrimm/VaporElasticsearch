import HTTP

public class ElasticsearchMapping: Codable {
    
    struct Mappings: Codable {
        var _doc: Properties
    }
    
    struct Properties: Codable {
        var properties: [String: ElasticsearchType]
    }
    
    var indexName: String? = nil
    var mappings = Mappings(_doc: Properties(properties: [String : ElasticsearchType]()))

    enum CodingKeys: String, CodingKey {
        case mappings
    }
    
    init(indexName: String) {
        self.indexName = indexName
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
