
import Foundation
import HTTP

extension ElasticsearchClient {
    public func bulkOperation(estimatedBodySize capacity: Int = 10 * 1024 * 1024)  -> ElasticsearchBulk {
        return ElasticsearchBulk(client: self, estimatedBodySize: capacity)
    }
}

public struct BulkHeader: Encodable {
    var index: String?
    var id: String?
    var type: String?
    var routing: String?
    var version: Int?
    var retryOnConflict: Int?
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case id = "_id"
        case type = "_type"
        case routing = "_routing"
        case version = "_version"
        case retryOnConflict = "retry_on_conflict"
    }
}

public class ElasticsearchBulk {
    var requestBody:Data
    let encoder = JSONEncoder()
    let client: ElasticsearchClient
    
    public var defaultHeader: BulkHeader = BulkHeader(index: nil, id: nil, type: "_doc", routing: nil, version: nil, retryOnConflict: nil)
    
    init(client: ElasticsearchClient, estimatedBodySize capacity: Int) {
        self.client = client
        requestBody = Data(capacity: capacity)
    }
    
    public func index<T: Codable>(
        doc :T,
        index: String? = nil,
        id: String? = nil,
        type: String? = nil,
        routing: String? = nil,
        version: Int? = nil
        ) throws {
        let header = ["index": mergeHeaders(defaultHeader, BulkHeader(index: index, id: id, type: type, routing: routing, version: version, retryOnConflict: nil))]
        // Add the header to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(header))
        requestBody.append(10)
        
        // Add the document to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(doc))
        requestBody.append(10)
    }
    
    public func create<T: Codable>(
        doc :T,
        index: String? = nil,
        id: String? = nil,
        type: String? = nil,
        routing: String? = nil,
        version: Int? = nil
        ) throws {
        let header = ["create": mergeHeaders(defaultHeader, BulkHeader(index: index, id: id, type: type, routing: routing, version: version, retryOnConflict: nil))]
        // Add the header to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(header))
        requestBody.append(10)
        
        // Add the document to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(doc))
        requestBody.append(10)
    }
    
    public func update<T: Codable>(
        doc :T,
        index: String? = nil,
        id: String? = nil,
        type: String? = nil,
        routing: String? = nil,
        version: Int? = nil,
        retryOnConflict: Int? = nil
        ) throws {
        let header = ["update": mergeHeaders(defaultHeader, BulkHeader(index: index, id: id, type: type, routing: routing, version: version, retryOnConflict: retryOnConflict))]
        // Add the header to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(header))
        requestBody.append(10)
        
        // Add the document to the request body followed by a newline character (newline -> 10)
        requestBody.append(try encoder.encode(doc))
        requestBody.append(10)
    }
    
    public func delete(
        id: String? = nil,
        index: String? = nil,
        type: String? = nil,
        routing: String? = nil,
        version: Int? = nil
        ) throws {
        let header = ["delete": mergeHeaders(defaultHeader, BulkHeader(index: index, id: id, type: type, routing: routing, version: version, retryOnConflict: nil))]
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
    
    private func mergeHeaders(_ base: BulkHeader, _ override: BulkHeader) -> BulkHeader {
        return BulkHeader(index: override.index ?? base.index,
                          id: override.id ?? base.id,
                          type: override.type ?? base.type,
                          routing: override.routing ?? base.routing,
                          version: override.version ?? base.version,
                          retryOnConflict: override.retryOnConflict ?? base.retryOnConflict)
    }
}
