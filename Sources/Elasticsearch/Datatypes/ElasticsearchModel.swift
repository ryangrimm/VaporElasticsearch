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

public protocol ElasticsearchModel {
    func toElasticsearchJSON() -> [String: Codable]
    init(fromElasticsearchResponse response: ElasticsearchDocResponse)
}

/*
public class ElasticsearchModelRegistry {
    static let sharedInstance = ElasticsearchModelRegistry()
    
    var indexNameToModelMapping = [String: ElasticsearchModel.Type]()
    
    private init() { }
    
    public static func registerModel(model: ElasticsearchModel.Type, toIndex indexName: String) {
        ElasticsearchModelRegistry.sharedInstance.indexNameToModelMapping[indexName] = model
    }
    
    public static func modelForIndexName(_ indexName: String) -> ElasticsearchModel.Type? {
        return ElasticsearchModelRegistry.sharedInstance.indexNameToModelMapping[indexName]
    }
}
*/
