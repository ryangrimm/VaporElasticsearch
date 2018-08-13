import HTTP

public struct ElasticsearchIndexSettings: Codable {
    public var index: IndexSettings? = nil
    public var analysis = Analysis()
    
    init(index: IndexSettings? = nil) {
        self.index = index
    }
    
    enum CodingKeys: String, CodingKey {
        case index
        case analysis
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(index, forKey: .index)
        if analysis.isEmpty() == false {
            try container.encode(analysis, forKey: .analysis)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decodeIfPresent(IndexSettings.self, forKey: .index)
        
        let analysisContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .index)
        if let analysis = try analysisContainer.decodeIfPresent(Analysis.self, forKey: DynamicKey(stringValue: "analysis")!) {
            self.analysis = analysis
        }
        else {
            self.analysis = Analysis()
        }
    }
}

public struct ElasticsearchIndexType: Codable {
    public var doc: DocumentTypeSettings
    
    public let type = "_doc"
    
    enum CodingKeys: String, CodingKey {
        case doc = "_doc"
    }
}

public struct ElasticsearchIndexAlias: Codable {
    var routing: String?
}

public protocol ElasticsearchIndex: Service {
    var indexName: String { get }
    var typeName: String { get }
}

public extension ElasticsearchIndex {
    /// Gets a document from Elasticsearch
    ///
    /// - Parameters:
    ///   - resultType: The model to decode the document into
    ///   - index: The index to get the document from
    ///   - id: The document id
    ///   - type: The document type
    ///   - routing: The routing information
    ///   - version: The version information
    ///   - storedFields: Only return the stored fields
    ///   - realtime: Fetch realtime results
    /// - Returns: A Future DocResponse
    public func get<T: Decodable>(
        on conn: DatabaseConnectable,
        decodeTo resultType: T.Type,
        id: String,
        routing: String? = nil,
        version: Int? = nil,
        storedFields: [String]? = nil,
        realtime: Bool? = nil
        ) -> Future<DocResponse<T>?> {
        let url = ElasticsearchClient.generateURL(path: "/\(self.indexName)/\(self.typeName)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        
        return conn.databaseConnection(to: .elasticsearch).flatMap { conn in
            return conn.send(HTTPMethod.GET, to: url.string!).map(to: DocResponse?.self) { jsonData in
                if let jsonData = jsonData {
                    return try conn.decoder.decode(DocResponse<T>.self, from: jsonData)
                }
                return nil
            }
        }
    }
    
    /// Index (save) a document
    ///
    /// - Parameters:
    ///   - doc: The document to index (save)
    ///   - index: The index to put the document into
    ///   - id: The id for the document. If not provided, an id will be automatically generated.
    ///   - type: The docuemnt type
    ///   - routing: Routing information for what node the document should be saved on
    ///   - version: Version information
    ///   - forceCreate: Force creation
    /// - Returns: A Future IndexResponse
    public func index<T: Encodable>(
        on conn: DatabaseConnectable,
        doc: T,
        id: String? = nil,
        routing: String? = nil,
        version: Int? = nil,
        forceCreate: Bool? = nil
        ) -> Future<IndexResponse> {
        let url = ElasticsearchClient.generateURL(path: "/\(self.indexName)/\(self.typeName)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
        let method = id != nil ? HTTPMethod.PUT : HTTPMethod.POST
        return conn.databaseConnection(to: .elasticsearch).flatMap { conn in
            let body: Data
            do {
                body = try conn.encoder.encode(doc)
            } catch {
                return conn.worker.future(error: error)
            }
            return conn.send(method, to: url.string!, with:body).map(to: IndexResponse.self) { jsonData in
                if let jsonData = jsonData {
                    return try conn.decoder.decode(IndexResponse.self, from: jsonData)
                }
                throw ElasticsearchError(identifier: "indexing_failed", reason: "Cannot index document", source: .capture(), statusCode: 404)
            }
        }
    }
    
    /// Updates the document stored at the given id with the given document
    ///
    /// - Parameters:
    ///   - doc: The document to update
    ///   - index: The document index
    ///   - id: The document id
    ///   - type: The document type
    ///   - routing: Routing information
    ///   - version: Version information
    /// - Returns: A Future IndexResponse
    public func update<T: Encodable>(
        on conn: DatabaseConnectable,
        doc: T,
        id: String,
        routing: String? = nil,
        version: Int? = nil
        ) -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(self.indexName)/\(self.typeName)/\(id)", routing: routing, version: version)
        return conn.databaseConnection(to: .elasticsearch).flatMap { conn in
            let body: Data
            do {
                body = try conn.encoder.encode(doc)
            } catch {
                return conn.worker.future(error: error)
            }
            return conn.send(HTTPMethod.PUT, to: url.string!, with:body).map(to: IndexResponse.self) {jsonData in
                if let jsonData = jsonData {
                    return try conn.decoder.decode(IndexResponse.self, from: jsonData)
                }
                throw ElasticsearchError(identifier: "indexing_failed", reason: "Cannot update document", source: .capture(), statusCode: 404)
            }
        }
    }
    
    /// Delete the document with the given id
    ///
    /// - Parameters:
    ///   - index: The document index
    ///   - id: The document id
    ///   - type: The document type
    ///   - routing: Routing information
    ///   - version: Version information
    /// - Returns: A Future IndexResponse
    public func delete(
        on conn: DatabaseConnectable,
        id: String,
        routing: String? = nil,
        version: Int? = nil
        ) -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(self.indexName)/\(self.typeName)/\(id)", routing: routing, version: version)
        return conn.databaseConnection(to: .elasticsearch).flatMap { conn in
            return conn.send(HTTPMethod.DELETE, to: url.string!).map(to: IndexResponse.self) {jsonData in
                if let jsonData = jsonData {
                    return try conn.decoder.decode(IndexResponse.self, from: jsonData)
                }
                throw ElasticsearchError(identifier: "indexing_failed", reason: "Cannot delete document", source: .capture(), statusCode: 404)
            }
        }
    }
}


public protocol ElasticsearchBuiltIndex: ElasticsearchIndex, Provider {
    var configuration: ElasticsearchIndexBuilder { get }
}

extension ElasticsearchBuiltIndex {
    public var indexName: String {
        get {
            return self.configuration.indexName
        }
    }
    public var typeName: String {
        get {
            return self.configuration.mapping.type
        }
    }
    
    func register(_ services: inout Services) throws {
    }
    
    public func willBoot(_ container: Container) throws -> Future<Void> {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        let config = try container.make(ElasticsearchClientConfig.self)
        return ElasticsearchClient.connect(config: config, on: group).flatMap(to: Void.self) { client in
            return client.fetchIndex(name: self.indexName).flatMap { index -> Future<Void> in
                if index != nil {
                    client.logger?.record(query: self.indexName + " index exists")
                    return .done(on: container)
                }
                
                return self.configuration.create(client: client).map(to: Void.self) { _ in
                    return
                }
            }
        }
    }
    
    func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}

public struct ElasticsearchFetchedIndex: ElasticsearchIndex {
    public let indexName: String
    public var typeName: String {
        get {
            return self.mapping.type
        }
    }
    public let mapping: ElasticsearchIndexType
    public let aliases: [String: ElasticsearchIndexAlias]
    public let settings: ElasticsearchIndexSettings
    
    internal init(indexName: String, mapping: ElasticsearchIndexType, aliases: [String: ElasticsearchIndexAlias], settings: ElasticsearchIndexSettings) {
        self.indexName = indexName
        self.mapping = mapping
        self.aliases = aliases
        self.settings = settings
    }
}
