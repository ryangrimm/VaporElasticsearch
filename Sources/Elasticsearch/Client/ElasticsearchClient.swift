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
    
    public let worker: Worker
    internal let encoder = JSONEncoder()
    internal let decoder = JSONDecoder()
    internal var isConnected: Bool
    
    /// Creates a new Elasticsearch client.
    init(client: HTTPClient, worker: Worker) {
        self.esConnection = client
        self.extend = [:]
        self.isClosed = false
        self.isConnected = false
        self.worker = worker
    }
    
    /// Closes this client.
    public func close() {
        self.isClosed = true
        esConnection.close().do() {
            self.isClosed = true
            self.isConnected = false
        }.catch() { error in
            self.isClosed = true
            self.isConnected = false
        }
    }

    internal static func generateURL(
        path: String,
        routing: String? = nil,
        version: Int? = nil,
        storedFields: [String]? = nil,
        realtime: Bool? = nil,
        forceCreate: Bool? = nil
    ) -> URLComponents {
        var url = URLComponents()
        url.path = path
        var query = [URLQueryItem]()
        if routing != nil {
            query.append(URLQueryItem(name: "routing", value: routing))
        }
        if version != nil {
            query.append(URLQueryItem(name: "version", value: "\(version!)"))
        }
        if storedFields != nil {
            query.append(URLQueryItem(name: "stored_fields", value: storedFields?.joined(separator: ",")))
        }
        if realtime != nil {
            query.append(URLQueryItem(name: "realtime", value: realtime! ? "true" : "false"))
        }
        url.queryItems = query
        
        return url
    }
    
    public func send(
        _ method: HTTPMethod,
        to path: String
    ) throws -> Future<Data> {
        var httpReq = HTTPRequest(method: method, url: path)
        httpReq.headers.add(name: "Content-Type", value: "application/json")
        return try send(httpReq)
    }
    
    public func send(
        _ method: HTTPMethod,
        to path: String,
        with body: Dictionary<String, Any>
    ) throws -> Future<Data> {
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        return try send(method, to: path, with: jsonData)
    }
    
    public func send(
        _ method: HTTPMethod,
        to path: String,
        with body: Data
    ) throws -> Future<Data> {
        var httpReq = HTTPRequest(method: method, url: path, body: HTTPBody(data: body))
        httpReq.headers.add(name: "Content-Type", value: "application/json")
        return try send(httpReq)
    }
    
    public func send(
        _ request: HTTPRequest
    ) throws -> Future<Data> {
        // XXX should be debug logged
        print(request.description)
        
        return self.esConnection.send(request).map(to: Data.self) { response in
            if response.body.data == nil {
                throw ElasticsearchError(identifier: "empty_response", reason: "Missing response body from Elasticsearch", source: .capture())
            }

            if response.status.code >= 400 {
                guard let json = try JSONSerialization.jsonObject(with: response.body.data!, options: []) as? [String: Any] else {
                    throw ElasticsearchError(identifier: "invalid_response", reason: "Cannot parse response body from Elasticsearch", source: .capture())
                }
                
                let error = json["error"] as! Dictionary<String, Any>
                throw ElasticsearchError(identifier: "elasticsearch_error", reason: error.description, source: .capture(), statusCode: response.status.code)
            }
            
            // XXX should be debug logged
            let bodyString = String(data: response.body.data!, encoding: String.Encoding.utf8) as String?
            print(bodyString!)
            
            return response.body.data!
        }
    }
}
