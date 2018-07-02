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
    ///   - onError: Error callback
    /// - Returns: An ElasticsearchClient Future
    public static func connect(
        config: ElasticsearchClientConfig,
        on worker: Worker,
        onError: @escaping (Error) -> Void
    ) -> Future<ElasticsearchClient> {
        let clientPromise = worker.eventLoop.newPromise(ElasticsearchClient.self)
        let scheme: HTTPScheme = config.useSSL ? .https : .http
        HTTPClient.connect(scheme: scheme, hostname: config.hostname, port: config.port, on: worker) { error in
            onError(error)
            clientPromise.fail(error: error)
        }.do() { client in
            let esClient = ElasticsearchClient.init(client: client, config: config, worker: worker)
            esClient.isConnected = true
            clientPromise.succeed(result: esClient)
        }.catch { error in
            onError(error)
            clientPromise.fail(error: error)
        }

        return clientPromise.futureResult
    }
}
