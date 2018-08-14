import HTTP
import Crypto

public protocol IndexFoundation: Service {
    var _indexName: String { get }
    var _typeName: String { get }
}

public extension IndexFoundation {
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
        let url = ElasticsearchClient.generateURL(path: "/\(self._indexName)/\(self._typeName)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        
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
        let url = ElasticsearchClient.generateURL(path: "/\(self._indexName)/\(self._typeName)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
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
        let url = ElasticsearchClient.generateURL(path: "/\(self._indexName)/\(self._typeName)/\(id)", routing: routing, version: version)
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
        let url = ElasticsearchClient.generateURL(path: "/\(self._indexName)/\(self._typeName)/\(id)", routing: routing, version: version)
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

public protocol ElasticsearchIndex: IndexFoundation, Provider, Encodable {
    var _indexName: String { get }
    var _indexSettings: IndexSettings { get }
    var _documentSettings: DocumentSettings { get }
    var _meta: [String: String] { get }
    var _keyMap: [String: String] { get }
}

extension ElasticsearchIndex {    
    public var _typeName: String {
        get {
            return "_doc"
        }
    }
    
    public var _indexSettings: IndexSettings {
        get {
            return IndexSettings(shards: 5, replicas: 1)
        }
    }
    
    public var _documentSettings: DocumentSettings {
        get {
            return DocumentSettings(dynamic: false, enabled: true)
        }
    }
    
    public var _meta: [String: String] {
        get {
            return [String: String]()
        }
    }
    
    public var _keyMap: [String: String] {
        get {
            return [String: String]()
        }
    }

    public func encode(to encoder: Encoder) throws {
        let builder = ElasticsearchIndexBuilder(indexName: _indexName)
        self._meta.forEach { (key, value) in
            builder.add(metaKey: key, metaValue: value)
        }
        builder.indexSettings(self._indexSettings)
        builder.mapping.doc.dynamic = self._documentSettings.dynamic
        builder.mapping.doc.enabled = self._documentSettings.enabled
        
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            if value is Mappable {
                let mappable = value as! Mappable
                let keyName = self._keyMap[label] ?? label
                builder.property(key: keyName, type: mappable)
            }
        }
        
        let propertiesJSON = try JSONEncoder().encode(builder.mapping.doc.properties.mapValues { AnyMap($0) })
        let digest = try SHA1.hash(propertiesJSON)
        if let _ = builder.mapping.doc.meta {
            builder.mapping.doc.meta!.private.propertiesHash = digest.hexEncodedString()
        }
        
        try builder.encode(to: encoder)
    }
    
    public func register(_ services: inout Services) throws {
    }
    
    public func willBoot(_ container: Container) throws -> Future<Void> {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        let config = try container.make(ElasticsearchClientConfig.self)
        return ElasticsearchClient.connect(config: config, on: group).flatMap(to: Void.self) { client in
            return client.fetchIndex(name: self._indexName).flatMap { index -> Future<Void> in
                if index != nil {
                    client.logger?.record(query: self._indexName + " index exists")
                    return .done(on: container)
                }
                
                let body = try JSONEncoder().encode(self)
                return client.send(HTTPMethod.PUT, to: "/\(self._indexName)", with: body).map { response -> Void in
                    return
                }
            }
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}
