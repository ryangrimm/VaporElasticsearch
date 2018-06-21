import Foundation

/// :nodoc:
public protocol ElasticsearchModel: Codable {
}

/// :nodoc:
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
