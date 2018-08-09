import Async
import HTTP

/**
 Connection methods
 */
extension ElasticsearchClient {    
    /// Connects to a Elasticsearch server over HTTP.
    ///
    /// - Parameters:
    ///   - config: The connection configuration to use
    ///   - worker: The worker to execute with
    /// - Returns: An ElasticsearchClient Future
    public static func connect(
        config: ElasticsearchClientConfig,
        on worker: Worker
    ) throws -> Future<ElasticsearchClient> {
        let clientPromise = worker.eventLoop.newPromise(ElasticsearchClient.self)
        let scheme: HTTPScheme = config.useSSL ? .https : .http
        HTTPClient.connect(scheme: scheme, hostname: config.hostname, port: config.port, on: worker) { error in
            let esError = ElasticsearchError(identifier: "connection_failed", reason: "Could not connect to Elasticsearch: " + error.localizedDescription, source: .capture())
            clientPromise.fail(error: esError)
        }.do() { client in
            let esClient = ElasticsearchClient.init(client: client, config: config, worker: worker)
            esClient.isConnected = true
            clientPromise.succeed(result: esClient)
        }.catch { error in
            let esError = ElasticsearchError(identifier: "connection_failed", reason: "Could not connect to Elasticsearch: " + error.localizedDescription, source: .capture())
            clientPromise.fail(error: esError)
        }

        return clientPromise.futureResult
    }
}
