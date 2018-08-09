import Async

extension ElasticsearchClient {
    public func fetchIndex(name: String) throws -> Future<ElasticsearchIndex?> {
        return try ElasticsearchIndex.fetch(indexName: name, client: self)
    }
    
    public func configureIndex(name: String) -> ElasticsearchIndex {
        return ElasticsearchIndex(indexName: name, client: self)
    }
    
    public func deleteIndex(name: String) throws -> Future<Void> {
        return try ElasticsearchIndex.delete(indexName: name, client: self)
    }
}
