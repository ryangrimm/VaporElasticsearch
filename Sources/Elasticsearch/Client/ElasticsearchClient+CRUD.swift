import HTTP

extension ElasticsearchClient {
    func get(index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil, storedFields: [String]? = nil, realtime: Bool? = nil) throws -> Future<ElasticsearchDocResponse> {
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        return try send(HTTPMethod.GET, to: url.string!).map(to: ElasticsearchDocResponse.self) {jsonData in
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return ElasticsearchDocResponse(json: json!)
        }
    }
    
    func index<T :ElasticsearchModel>(doc :T, index: String, id: String?, type: String = "_doc", routing: String? = nil, version: Int? = nil, forceCreate: Bool? = nil) throws -> Future<ElasticsearchIndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
        let method = id != nil ? HTTPMethod.PUT : HTTPMethod.POST
        let body = doc.toElasticsearchJSON()
        return try send(method, to: url.string!, with:body).map(to: ElasticsearchIndexResponse.self) {jsonData in
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return ElasticsearchIndexResponse(json: json!)
        }
    }

    func update<T :ElasticsearchModel>(doc :T, index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil) throws -> Future<ElasticsearchUpdateResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        let body = doc.toElasticsearchJSON()
        return try send(HTTPMethod.PUT, to: url.string!, with:body).map(to: ElasticsearchUpdateResponse.self) {jsonData in
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return ElasticsearchUpdateResponse(json: json!)
        }
    }

    func delete(index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil) throws -> Future<ElasticsearchDeleteResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        return try send(HTTPMethod.DELETE, to: url.string!).map(to: ElasticsearchDeleteResponse.self) {jsonData in
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return ElasticsearchDeleteResponse(json: json!)
        }
    }
}
