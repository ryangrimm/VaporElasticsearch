import HTTP

extension ElasticsearchClient {
    func get<T: ElasticsearchModel>(
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
    
    func index<T :ElasticsearchModel>(
        doc :T,
        index: String,
        id: String? = nil,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil,
        forceCreate: Bool? = nil
    ) throws -> Future<IndexResponse> {
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
        let method = id != nil ? HTTPMethod.PUT : HTTPMethod.POST
        let body = try self.encoder.encode(doc)
        return try send(method, to: url.string!, with:body).map(to: IndexResponse.self) {jsonData in
            return try self.decoder.decode(IndexResponse.self, from: jsonData)
        }
    }

    func update<T :ElasticsearchModel>(
        doc :T,
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
    ) throws -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        let body = try self.encoder.encode(doc)
        return try send(HTTPMethod.PUT, to: url.string!, with:body).map(to: IndexResponse.self) {jsonData in
            return try self.decoder.decode(IndexResponse.self, from: jsonData)
        }
    }

    func delete(
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
    ) throws -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        return try send(HTTPMethod.DELETE, to: url.string!).map(to: IndexResponse.self) {jsonData in
            return try self.decoder.decode(IndexResponse.self, from: jsonData)
        }
    }
}
