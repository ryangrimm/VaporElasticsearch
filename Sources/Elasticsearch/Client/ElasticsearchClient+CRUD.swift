import HTTP

internal enum ResponseResultType: String {
    case created = "created"
    case updated = "updated"
    case deleted = "deleted"
    case noop = "noop"
}

internal struct ResponseBodyIndex {
    let shards :(total: Int, failed: Int, successful: Int)
    let index :String
    let type :String
    let id :String
    let version :Int
    let result :ResponseResultType
    let seqNo: Int
    var routing :String?

    init(json: Dictionary<String, Any>) {
        index = json["_index"] as! String
        type = json["_type"] as! String
        id = json["_id"] as! String
        version = json["_version"] as! Int
        result = ResponseResultType(rawValue: json["result"] as! String)!
        seqNo = json["_seq_no"] as! Int
        
        let jsonShards = json["_shards"] as! Dictionary<String, Int>
        shards = (total: jsonShards["total"]!, failed: jsonShards["failed"]!, successful: jsonShards["successful"]!)
    }
}

typealias ResponseBodyUpdate = ResponseBodyIndex
typealias ResponseBodyDelete = ResponseBodyIndex


extension ElasticsearchClient {
    func get(index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil, storedFields: [String]? = nil, realtime: Bool? = nil) throws -> Future<ElasticsearchDocResponse> {
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        return try send(HTTPMethod.GET, to: url.string!).map(to: ElasticsearchDocResponse.self) {jsonData in
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return ElasticsearchDocResponse(json: json!)
        }
    }
    
    func index<T :ElasticsearchModel>(doc :T, index: String, id: String?, type: String = "_doc", routing: String? = nil, version: Int? = nil, forceCreate: Bool? = nil) throws -> Future<ResponseBodyIndex>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
        let method = id != nil ? HTTPMethod.PUT : HTTPMethod.POST
        let body = doc.toElasticsearchJSON()
        return try send(method, to: url.string!, with:body).map(to: ResponseBodyIndex.self) {jsonData in
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return ResponseBodyIndex(json: json!)
        }
    }

    func update<T :ElasticsearchModel>(doc :T, index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil) throws -> Future<ResponseBodyUpdate>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        let body = doc.toElasticsearchJSON()
        return try send(HTTPMethod.PUT, to: url.string!, with:body).map(to: ResponseBodyUpdate.self) {jsonData in
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return ResponseBodyUpdate(json: json!)
        }
    }

    func delete(index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil) throws -> Future<ResponseBodyDelete>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        return try send(HTTPMethod.PUT, to: url.string!).map(to: ResponseBodyDelete.self) {jsonData in
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return ResponseBodyDelete(json: json!)
        }
    }
}
