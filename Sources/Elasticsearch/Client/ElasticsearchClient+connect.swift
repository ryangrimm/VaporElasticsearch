import Async
import HTTP

/**
 Connection methods
 */
extension ElasticsearchClient {
    /// Connects to a Elasticsearch server over HTTP.
    ///
    /// - Parameters:
    ///   - hostname: Hostname for the server
    ///   - port: Port for the server
    ///   - username: currently unused
    ///   - password: currently unused
    ///   - worker: The worker to execute with
    ///   - onError: Error callback
    /// - Returns: An ElasticsearchClient Future
    public static func connect(
        hostname: String = "localhost",
        port: Int = 9200,
        username: String? = nil,
        password: String? = nil,
        on worker: Worker,
        onError: @escaping (Error) -> Void
    ) -> Future<ElasticsearchClient> {
        let clientPromise = worker.eventLoop.newPromise(ElasticsearchClient.self)
        HTTPClient.connect(hostname: hostname, port: port, on: worker) { error in
            onError(error)
            clientPromise.fail(error: error)
        }.do() { client in
            let esClient = ElasticsearchClient.init(client: client, worker: worker)
            esClient.isConnected = true
            clientPromise.succeed(result: esClient)
        }.catch { error in
            onError(error)
            clientPromise.fail(error: error)
        }

        return clientPromise.futureResult
    }
}
