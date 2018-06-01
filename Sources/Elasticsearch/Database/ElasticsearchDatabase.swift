import HTTP

public final class ElasticsearchDatabase: Database {
    /// This client's configuration.
    public let config: ElasticsearchClientConfig
    
    /// Creates a new `ElasticsearchDatabase`.
    public init(config: ElasticsearchClientConfig) throws {
        self.config = config
    }
    
    public init(url: URL) throws {
        self.config = ElasticsearchClientConfig(url: url)
    }
    
    /// See `Database`.
    public func newConnection(on worker: Worker) -> EventLoopFuture<ElasticsearchClient> {
        return ElasticsearchClient.connect(hostname: config.hostname, port: config.port, username: config.username, password: config.password, on: worker) { error in
            print("[Elasticsearch] \(error)")
        }
    }
}

extension DatabaseIdentifier {
    /// Default identifier for `ElasticsearchClient`.
    public static var elasticsearch: DatabaseIdentifier<ElasticsearchDatabase> {
        return .init("elasticsearch")
    }
}
