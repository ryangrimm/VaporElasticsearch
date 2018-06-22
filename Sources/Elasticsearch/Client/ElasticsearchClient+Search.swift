import HTTP

/**
 Search methods.
 */
extension ElasticsearchClient {
    /// Execute a search in a given index
    ///
    /// - Parameters:
    ///   - resultType: A struct or class that conforms to the Decodable protocol and can properly decode the documents stored in the index
    ///   - index: The index to execute the query against
    ///   - query: A SearchContainer object that specifies the query to execute
    ///   - type: The index type (defaults to _doc)
    ///   - routing: Routing information
    /// - Returns: A Future SearchResponse
    /// - Throws: ElasticsearchError
    public func search<U: Decodable>(
        decodeTo resultType: U.Type,
        index: String,
        query: SearchContainer,
        type: String = "_doc",
        routing: String? = nil
    ) throws -> Future<SearchResponse<U>> {
        let body = try self.encoder.encode(query)
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/_search", routing: routing)
        return try send(HTTPMethod.POST, to: url.string!, with: body).map(to: SearchResponse.self) {jsonData in
            return try self.decoder.decode(SearchResponse<U>.self, from: jsonData)
        }
    }
}
