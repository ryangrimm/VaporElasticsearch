import HTTP

extension ElasticsearchClient {
    public func search<T: ElasticsearchModel>(
        decodeTo resultType: T.Type,
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil,
        storedFields: [String]? = nil,
        realtime: Bool? = nil
        ) throws -> Future<DocResponse<T>> {
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        return try send(HTTPMethod.GET, to: url.string!).map(to: DocResponse.self) {jsonData in
            return try self.decoder.decode(DocResponse<T>.self, from: jsonData)
        }
    }
    
    public func search<T: QueryElement, U: Decodable>(
        decodeTo resultType: U.Type,
        index: String,
        query: QueryContainer<T>,
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
