import Foundation

/// Config options for an `ElasticsearchClient`.
public struct ElasticsearchClientConfig: Codable {
    /// The Elasticsearch server's hostname.
    public var hostname: String

    /// The Elasticsearch server's port.
    public var port: Int
    
    /// The Elasticsearch server's optional username.
    public var username: String?
    
    /// The Elasticsearch server's optional password.
    public var password: String?
    
    /// If wanting to use Elasticsearch as a key/value store `enableKeyedCache` must be set to `true`.
    /// This will create a new index in Elasticsearch automatically. By default the name of this
    /// index is "_vapor_keyed_cache" but can be controlled via the `keyedCacheIndexName`.
    /// If `enableKeyedCache` was set to `true` and then later set to `false`, the Elasticsearch
    /// index will be deleted.
    public var enableKeyedCache: Bool = false
    
    /// Name of the index to use for the keyed cache
    public var keyedCacheIndexName: String = "_vapor_keyed_cache"

    /// Create a new `ElasticsearchClientConfig`
    public init(url: URL) {
        self.hostname = url.host ?? "localhost"
        self.port = url.port ?? 9200
        self.username = url.user
        self.password = url.password
    }

    public init() {
        self.hostname = "localhost"
        self.port = 9200
    }
}
