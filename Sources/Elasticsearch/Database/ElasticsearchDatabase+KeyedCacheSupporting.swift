import Foundation
import DatabaseKit

extension ElasticsearchDatabase: KeyedCacheSupporting {
    public static func keyedCacheGet<D>(_ key: String, as decodable: D.Type, on conn: ElasticsearchClient) throws -> EventLoopFuture<D?> where D : Decodable {
        return conn.get(decodeTo: D.self, index: conn.config.keyedCacheIndexModel.indexName, id: key).map(to: D?.self) { result in
            if let result = result {
                return result.source
            }
            return nil
        }
    }
    
    public static func keyedCacheSet<E>(_ key: String, to encodable: E, on conn: ElasticsearchClient) throws -> EventLoopFuture<Void> where E : Encodable {
        return conn.index(doc: encodable, index: conn.config.keyedCacheIndexModel.indexName, id: key).map(to: Void.self, { _ in
            return
        })
    }
    
    public static func keyedCacheRemove(_ key: String, on conn: ElasticsearchClient) throws -> EventLoopFuture<Void> {
        return conn.delete(index: conn.config.keyedCacheIndexModel.indexName, id: key).map(to: Void.self) { _ in
            return
        }
    }
}
