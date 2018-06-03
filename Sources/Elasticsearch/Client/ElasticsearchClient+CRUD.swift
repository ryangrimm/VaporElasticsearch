import HTTP

internal enum ResponseResultType: String {
    case created = "created"
    case updated = "updated"
    case deleted = "deleted"
    case noop = "noop"
}

internal struct ResponseBodyGet: Decodable {
    let index :String
    let type :String
    let id :String
    let version :Int
    let source :Dictionary<String, Any>
    var fields :Dictionary<String, Any>? = nil
    var routing :String? = nil
    
    enum CodingKeys: String, CodingKey
    {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        index = try values.decode(String.self, forKey: .index)
        type = try values.decode(String.self, forKey: .type)
        id = try values.decode(String.self, forKey: .id)
        version = try values.decode(Int.self, forKey: .version)
        
        // XXX temporary, need to sort this out once we have models
        source = ["fake": "data"]
    }
}

internal struct ResponseBodyIndex: Decodable {
    let shards :(total: Int, failed: Int, successful: Int)
    let index :String
    let type :String
    let id :String
    let version :Int
    let result :ResponseResultType
    let seqNo: Int
    var routing :String?
    
    enum CodingKeys: String, CodingKey
    {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case result
        case seqNo = "_seq_no"
    }
    
    enum ShardsKeys: String, CodingKey {
        case total
        case failed
        case successful
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        index = try values.decode(String.self, forKey: .index)
        type = try values.decode(String.self, forKey: .type)
        id = try values.decode(String.self, forKey: .id)
        version = try values.decode(Int.self, forKey: .version)
        result = ResponseResultType(rawValue: try values.decode(String.self, forKey: .result))!
        seqNo = try values.decode(Int.self, forKey: .seqNo)
        
        let shards = try values.nestedContainer(keyedBy: ShardsKeys.self, forKey: .shards)
        let total = try shards.decode(Int.self, forKey: .total)
        let failed = try shards.decode(Int.self, forKey: .failed)
        let successful = try shards.decode(Int.self, forKey: .successful)
        self.shards = (total: total, failed: failed, successful: successful)
    }
}

typealias ResponseBodyUpdate = ResponseBodyIndex
typealias ResponseBodyDelete = ResponseBodyIndex


extension ElasticsearchClient {
    func get(index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil, storedFields: [String]? = nil, realtime: Bool? = nil) throws -> Future<ResponseBodyGet>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        return try send(HTTPMethod.GET, to: url.string!).map(to: ResponseBodyGet.self) {jsonData in
            return try JSONDecoder().decode(ResponseBodyGet.self, from: jsonData)
        }
    }
    
    func index<T :Encodable>(doc :T, index: String, id: String?, type: String = "_doc", routing: String? = nil, version: Int? = nil, forceCreate: Bool? = nil) throws -> Future<ResponseBodyIndex>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
        return try send(id != nil ? HTTPMethod.PUT : HTTPMethod.POST, to: url.string!, with:doc).map(to: ResponseBodyIndex.self) {jsonData in
            return try JSONDecoder().decode(ResponseBodyIndex.self, from: jsonData)
        }
    }

    func update<T :Encodable>(doc :T, index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil) throws -> Future<ResponseBodyUpdate>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        return try send(HTTPMethod.PUT, to: url.string!, with:doc).map(to: ResponseBodyUpdate.self) {jsonData in
            return try JSONDecoder().decode(ResponseBodyUpdate.self, from: jsonData)
        }
    }

    func delete(index: String, id: String, type: String = "_doc", routing: String? = nil, version: Int? = nil) throws -> Future<ResponseBodyDelete>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        return try send(HTTPMethod.PUT, to: url.string!).map(to: ResponseBodyDelete.self) {jsonData in
            return try JSONDecoder().decode(ResponseBodyDelete.self, from: jsonData)
        }
    }
}
