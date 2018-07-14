
import Foundation
import HTTP

extension ElasticsearchClient {
    public func bulkOperation(capacity: Int = 10 * 1024 * 1024) -> ElasticsearchBulk {
        return ElasticsearchBulk(client: self, capacity: capacity)
    }
}

public class ElasticsearchBulk {
    var requestBody:Data
    let encoder = JSONEncoder()
    let client: ElasticsearchClient
    
    init(client: ElasticsearchClient, capacity: Int) {
        self.client = client
        requestBody = Data(capacity: capacity)
    }
    
    struct BasicHeader: Encodable {
        let index: String
        let id: String?
        let type: String
        let routing: String?
        let version: Int?
        
        enum CodingKeys: String, CodingKey {
            case index = "_index"
            case id = "_id"
            case type = "_type"
            case routing = "_routing"
            case version = "_version"
        }
    }
    
    struct UpdateHeader: Encodable {
        let index: String
        let id: String?
        let type: String
        let routing: String?
        let version: Int?
        let retryOnConflict: Int?
        
        enum CodingKeys: String, CodingKey {
            case index = "_index"
            case id = "_id"
            case type = "_type"
            case routing = "_routing"
            case version = "_version"
            case retryOnConflict = "retry_on_conflict"
        }
    }
    
    public func index<T: Codable>(
        doc :T,
        index: String,
        id: String? = nil,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
        ) throws {
        let header = ["index": BasicHeader(index: index, id: id, type: type, routing: routing, version: version)]
        // Add the header to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(header))
        requestBody.append(10)
        
        // Add the document to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(doc))
        requestBody.append(10)
    }
    
    public func create<T: Codable>(
        doc :T,
        index: String,
        id: String? = nil,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
        ) throws {
        let header = ["create": BasicHeader(index: index, id: id, type: type, routing: routing, version: version)]
        // Add the header to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(header))
        requestBody.append(10)
        
        // Add the document to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(doc))
        requestBody.append(10)
    }
    
    public func update<T: Codable>(
        doc :T,
        index: String,
        id: String? = nil,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil,
        retryOnConflict: Int? = nil
        ) throws {
        let header = ["update": UpdateHeader(index: index, id: id, type: type, routing: routing, version: version, retryOnConflict: retryOnConflict)]
        // Add the header to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(header))
        requestBody.append(10)
        
        // Add the document to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(doc))
        requestBody.append(10)
    }
    
    public func delete(
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
        ) throws {
        let header = ["delete": BasicHeader(index: index, id: id, type: type, routing: routing, version: version)]
        // Add the header to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(header))
        requestBody.append(10)
    }
    
    public func send() throws -> Future<BulkResponse> {
        // Add on a newline at the end to signal the end of the commands
        requestBody.append(10)

        let url = ElasticsearchClient.generateURL(path: "/_bulk")
        var request = HTTPRequest(method: HTTPMethod.POST, url: url.string!, body: HTTPBody(data: requestBody))
        request.headers.add(name: "Content-Type", value: "application/x-ndjson")

        return try client.send(request).map(to: BulkResponse.self) {jsonData in
            return try JSONDecoder().decode(BulkResponse.self, from: jsonData)
        }
    }
}
