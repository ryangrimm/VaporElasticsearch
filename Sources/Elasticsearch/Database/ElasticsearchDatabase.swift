import DatabaseKit
import Async

public final class ElasticsearchDatabase: Database {
    public typealias Connection = ElasticsearchClient
    
    /// This client's configuration.
    public let config: ElasticsearchClientConfig
    
    /// Creates a new `ElasticsearchDatabase`.
    public init(config: ElasticsearchClientConfig) { 
        self.config = config
    }
    
    public init(url: URL) {
        self.config = ElasticsearchClientConfig(url: url)
    }
    
    /// See `Database`.
    public func newConnection(on worker: Worker) -> Future<ElasticsearchClient> {
        return ElasticsearchClient.connect(config: config, on: worker)
    }
}

/// :nodoc:
extension DatabaseIdentifier {
    /// Default identifier for `ElasticsearchClient`.
    public static var elasticsearch: DatabaseIdentifier<ElasticsearchDatabase> {
        return .init("elasticsearch")
    }
}
