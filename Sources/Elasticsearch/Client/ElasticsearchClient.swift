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
