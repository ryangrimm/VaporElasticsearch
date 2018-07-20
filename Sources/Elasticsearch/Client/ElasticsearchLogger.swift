import Async

/// An Elasticsearch logger.
public protocol ElasticsearchLogger {
    /// Log the request/response.
    func log(query: String)
}

extension DatabaseLogger: ElasticsearchLogger {
    public func log(query: String) {
        record(query: query, values: [])
    }
}
