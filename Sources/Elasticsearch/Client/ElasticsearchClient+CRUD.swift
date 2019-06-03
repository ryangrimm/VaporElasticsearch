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
    public func get<T: Decodable>(
        decodeTo resultType: T.Type,
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil,
        storedFields: [String]? = nil,
        realtime: Bool? = nil
    ) -> Future<DocResponse<T>?> {
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        return send(HTTPMethod.GET, to: url.string!).map(to: DocResponse?.self) {jsonData in
            if let jsonData = jsonData {
                return try self.decoder.decode(DocResponse<T>.self, from: jsonData)
            }
            return nil
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
        doc: T,
        index: String,
        id: String? = nil,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil,
        forceCreate: Bool? = nil
    ) -> Future<IndexResponse> {
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
        let method = id != nil ? HTTPMethod.PUT : HTTPMethod.POST
        let body: Data
        do {
            body = try self.encoder.encode(doc)
        } catch {
            return worker.future(error: error)
        }
        return send(method, to: url.string!, with:body).map(to: IndexResponse.self) {jsonData in
            if let jsonData = jsonData {
                return try self.decoder.decode(IndexResponse.self, from: jsonData)
            }
            throw ElasticsearchError(identifier: "indexing_failed", reason: "Cannot index document", source: .capture(), statusCode: 404)
        }
    }

    /// Update a document stored at the given id without sending the
    /// whole document in the request ("partial update").
    ///
    /// Send either a partial document (`doc` ) which will be deeply merged into an existing document,
    /// or a `script`, which will update the document content
    ///
    /// Script will take priority over a doc if both are set.
    ///
    /// - Parameters:
    ///   - doc: The document to update
    ///   - index: The document index
    ///   - id: The document id
    ///   - type: The document type
    ///   - routing: Routing information
    ///   - version: Version information
    ///   - docAsUpsert: index doc if it does not exist
    /// - Returns: A Future IndexResponse
    ///
    public func update<T: Encodable>(
        doc: T,
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil,
        docAsUpsert: Bool = false
    ) -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)/_update", routing: routing, version: version)
        let body: Data
        do {
            let updateDoc = UpdateDoc(doc: doc, docAsUpsert: docAsUpsert)
            body = try self.encoder.encode(updateDoc)
        } catch {
            return worker.future(error: error)
        }
        return update(url: url, body: body)
    }

    /// - Parameters:
    ///   - script: The Script to execute
    ///   - index: The document index
    ///   - id: The document id
    ///   - type: The document type
    ///   - routing: Routing information
    ///   - version: Version information
    /// - Returns: A Future IndexResponse
    ///
    public func update(
        script: Script,
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
    ) -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)/_update", routing: routing, version: version)
        let body: Data
        do {
            let updateScript = UpdateScript(script: script)
            body = try self.encoder.encode(updateScript)
        } catch {
            return worker.future(error: error)
        }
        return update(url: url, body: body)
    }

    fileprivate func update(
        url: URLComponents,
        body: Data
    ) -> Future<IndexResponse>{
        return send(HTTPMethod.POST, to: url.string!, with:body).map(to: IndexResponse.self) {jsonData in
            if let jsonData = jsonData {
                return try self.decoder.decode(IndexResponse.self, from: jsonData)
            }
            throw ElasticsearchError(identifier: "indexing_failed", reason: "Cannot update document", source: .capture(), statusCode: 404)
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
        index: String,
        id: String,
        type: String = "_doc",
        routing: String? = nil,
        version: Int? = nil
    ) -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(index)/\(type)/\(id)", routing: routing, version: version)
        return send(HTTPMethod.DELETE, to: url.string!).map(to: IndexResponse.self) {jsonData in
            if let jsonData = jsonData {
                return try self.decoder.decode(IndexResponse.self, from: jsonData)
            }
            throw ElasticsearchError(identifier: "indexing_failed", reason: "Cannot delete document", source: .capture(), statusCode: 404)
        }
    }
}
