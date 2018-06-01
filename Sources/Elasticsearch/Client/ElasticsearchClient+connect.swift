import Async
import HTTP

extension ElasticsearchClient {
    /// Connects to a Elasticsearch server over HTTP(S).
    public static func connect(
        hostname: String = "localhost",
        port: Int = 9200,
        username: String? = nil,
        password: String? = nil,
        on worker: Worker,
        onError: @escaping (Error) -> Void
        ) -> Future<ElasticsearchClient> {
        
        let clientPromise = worker.eventLoop.newPromise(ElasticsearchClient.self)
        HTTPClient.connect(hostname: hostname, port: port, on: worker) {error in
                clientPromise.fail(error: error)
            }.do() { client in
            let esClient = ElasticsearchClient.init(client: client, worker: worker)
            clientPromise.succeed(result: esClient)
            }.catch { error in
                clientPromise.fail(error: error)
            }

        return clientPromise.futureResult
    }
}
