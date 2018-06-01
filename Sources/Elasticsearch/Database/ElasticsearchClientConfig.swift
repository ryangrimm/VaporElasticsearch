/// Config options for a `ElasticsearchClient.
public struct ElasticsearchClientConfig: Codable {
    /// The Elasticsearch server's hostname.
    public var hostname: String

    /// The Elasticsearch server's port.
    public var port: Int
    
    /// The Elasticsearch server's optional username.
    public var username: String?
    
    /// The Elasticsearch server's optional password.
    public var password: String?

    /// Create a new `RedisClientConfig`
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
