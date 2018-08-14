import Async
import HTTP

extension ElasticsearchClient {
    public func fetchIndex(name: String) -> Future<ElasticsearchFetchedIndex?> {
        return ElasticsearchFetchedIndex.fetch(indexName: name, client: self)
    }
    
    public func configureIndex(name: String, dynamicMapping: Bool = false, enableQuerying: Bool = true) -> ElasticsearchIndexBuilder {
        return ElasticsearchIndexBuilder(indexName: name, dynamicMapping: dynamicMapping, enableQuerying: enableQuerying)
    }
    
    public func deleteIndex(name: String) -> Future<Void> {
        return self.send(HTTPMethod.DELETE, to: "/\(name)").map(to: Void.self) { response in
        }
    }
}
