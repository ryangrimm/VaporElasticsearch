import Foundation

public struct ElasticsearchDocResponse {
    let index :String
    let type :String
    let id :String
    let version :Int
    var source :Dictionary<String, Any>
    var routing :String? = nil
    
    init(json: Dictionary<String, Any>) {
        index = json["_index"] as! String
        type = json["_type"] as! String
        id = json["_id"] as! String
        version = json["_version"] as! Int
        source = json["_source"] as! Dictionary<String, Any>
    }
}

internal enum ElasticsearchResponseResultType: String {
    case created = "created"
    case updated = "updated"
    case deleted = "deleted"
    case noop = "noop"
}

internal struct ElasticsearchIndexResponse {
    let shards :(total: Int, failed: Int, successful: Int)
    let index :String
    let type :String
    let id :String
    let version :Int
    let result :ElasticsearchResponseResultType
    let seqNo: Int
    var routing :String?
    
    init(json: Dictionary<String, Any>) {
        index = json["_index"] as! String
        type = json["_type"] as! String
        id = json["_id"] as! String
        version = json["_version"] as! Int
        result = ElasticsearchResponseResultType(rawValue: json["result"] as! String)!
        seqNo = json["_seq_no"] as! Int
        
        let jsonShards = json["_shards"] as! Dictionary<String, Int>
        shards = (total: jsonShards["total"]!, failed: jsonShards["failed"]!, successful: jsonShards["successful"]!)
    }
}

typealias ElasticsearchUpdateResponse = ElasticsearchIndexResponse
typealias ElasticsearchDeleteResponse = ElasticsearchIndexResponse


public protocol ElasticsearchModel {
    static var elasticsearchIndex: String { get }
    
    init(fromElasticsearchResponse response: ElasticsearchDocResponse)
    func toElasticsearchJSON() -> [String: Codable]

}

extension ElasticsearchModel {
    static func get<T: ElasticsearchModel>(_ id: String, client: ElasticsearchClient) throws -> Future<T> {
        return try client.get(index: self.elasticsearchIndex, id: id).map(to: T.self) { response in
            return T.init(fromElasticsearchResponse: response)
        }
    }
    
    func save(client: ElasticsearchClient) throws -> Future<ElasticsearchIndexResponse> {
        return try save(nil, client: client)
    }
    
    func save(_ id: String?, client: ElasticsearchClient) throws -> Future<ElasticsearchIndexResponse> {
        return try client.index(doc: self, index: type(of: self).elasticsearchIndex, id: id)
    }
    
    func delete(_ id: String, client: ElasticsearchClient) throws -> Future<ElasticsearchDeleteResponse> {
        return try client.delete(index: type(of: self).elasticsearchIndex, id: id)
    }
}

public class ElasticsearchModelRegistry {
    static let sharedInstance = ElasticsearchModelRegistry()
    
    var indexNameToModelMapping = [String: ElasticsearchModel.Type]()
    
    private init() { }
    
    public static func registerModel(model: ElasticsearchModel.Type, toIndex indexName: String) {
        ElasticsearchModelRegistry.sharedInstance.indexNameToModelMapping[indexName] = model
    }
    
    public static func modelForIndexName(_ indexName: String) throws -> ElasticsearchModel.Type {
        let modelType: ElasticsearchModel.Type? = ElasticsearchModelRegistry.sharedInstance.indexNameToModelMapping[indexName]
        if modelType == nil {
            
        }
        
        return modelType!
    }
}
