import HTTP

/// A Elasticsearch client.
public final class ElasticsearchClient: DatabaseConnection, BasicWorker {
    /// See `BasicWorker`.
    public var eventLoop: EventLoop {
        return worker.eventLoop
    }
    
    /// See `DatabaseConnection`.
    public var isClosed: Bool
    
    /// See `Extendable`.
    public var extend: Extend
    
    /// The HTTP connection
    private let esConnection: HTTPClient
    
    private let worker: Worker
    
    /// Creates a new Elasticsearch client.
    init(client: HTTPClient, worker: Worker) {
        self.esConnection = client
        self.extend = [:]
        self.isClosed = false
        self.worker = worker
    }
    
    /// Closes this client.
    public func close() {
        self.isClosed = true
        esConnection.close().do() {
            self.isClosed = true
            }.catch() { error in
                self.isClosed = true
        }
    }
}

/// MARK: Config

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
