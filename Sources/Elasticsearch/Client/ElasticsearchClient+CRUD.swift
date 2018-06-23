import HTTP

/**
 CRUD methods.
 */
extension ElasticsearchClient {
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
    /// - Throws: ElasticsearchError
    public func get<T: Codable>(
        decodeTo resultType: T.Type,
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil,
        storedFields: [String]? = nil,
        realtime: Bool? = nil
    ) throws -> Future<DocResponse<T>> {
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        return try send(HTTPMethod.GET, to: url.string!).map(to: DocResponse.self) {jsonData in
            return try self.decoder.decode(DocResponse<T>.self, from: jsonData)
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
    /// - Throws: ElasticsearchError
    public func index<T :Codable>(
        doc :T,
        index: String,
        id: String? = nil,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil,
        forceCreate: Bool? = nil
    ) throws -> Future<IndexResponse> {
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
        let method = id != nil ? HTTPMethod.PUT : HTTPMethod.POST
        let body = try self.encoder.encode(doc)
        return try send(method, to: url.string!, with:body).map(to: IndexResponse.self) {jsonData in
            return try self.decoder.decode(IndexResponse.self, from: jsonData)
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
    /// - Throws: ElasticsearchError
    public func update<T :Codable>(
        doc :T,
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
    ) throws -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        let body = try self.encoder.encode(doc)
        return try send(HTTPMethod.PUT, to: url.string!, with:body).map(to: IndexResponse.self) {jsonData in
            return try self.decoder.decode(IndexResponse.self, from: jsonData)
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
    /// - Throws: ElasticsearchError
    public func delete(
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
    ) throws -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        return try send(HTTPMethod.DELETE, to: url.string!).map(to: IndexResponse.self) {jsonData in
            return try self.decoder.decode(IndexResponse.self, from: jsonData)
        }
    }
}
