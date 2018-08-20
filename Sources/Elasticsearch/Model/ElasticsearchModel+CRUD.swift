
import Foundation
import HTTP

extension ElasticsearchBaseModel {
    /// Gets a document from Elasticsearch
    ///
    /// - Parameters:
    ///   - id: The document id
    ///   - routing: The routing information
    ///   - version: The version information
    ///   - storedFields: Only return the stored fields
    ///   - realtime: Fetch realtime results
    /// - Returns: A Future DocResponse
    public static func get(
        on conn: DatabaseConnectable,
        id: String,
        routing: String? = nil,
        version: Int? = nil,
        storedFields: [String]? = nil,
        realtime: Bool? = nil
        ) -> Future<DocResponse<Self>?> {
        let url = ElasticsearchClient.generateURL(path: "/\(self.indexName)/\(self.typeName)/\(id)", routing: routing, version: version, storedFields: storedFields, realtime: realtime)
        
        return conn.databaseConnection(to: .elasticsearch).flatMap { conn in
            return conn.send(HTTPMethod.GET, to: url.string!).map(to: DocResponse?.self) { jsonData in
                if let jsonData = jsonData {
                    return try conn.decoder.decode(DocResponse<Self>.self, from: jsonData)
                }
                return nil
            }
        }
    }
    
    /// Index (save) a document
    ///
    /// - Parameters:
    ///   - id: The id for the document. If not provided, an id will be automatically generated.
    ///   - routing: Routing information for what node the document should be saved on
    ///   - version: Version information
    ///   - forceCreate: Force creation
    /// - Returns: A Future IndexResponse
    public func index(
        on conn: DatabaseConnectable,
        id: String? = nil,
        routing: String? = nil,
        version: Int? = nil,
        forceCreate: Bool? = nil
        ) -> Future<IndexResponse> {
        let url = ElasticsearchClient.generateURL(path: "/\(Self.indexName)/\(Self.typeName)/\(id ?? "")", routing: routing, version: version, forceCreate: forceCreate)
        let method = id != nil ? HTTPMethod.PUT : HTTPMethod.POST
        return conn.databaseConnection(to: .elasticsearch).flatMap { conn in
            let body: Data
            do {
                body = try conn.encoder.encode(self)
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
    ///   - id: The document id
    ///   - routing: Routing information
    ///   - version: Version information
    /// - Returns: A Future IndexResponse
    public func update(
        on conn: DatabaseConnectable,
        id: String,
        routing: String? = nil,
        version: Int? = nil
        ) -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(Self.indexName)/\(Self.typeName)/\(id)", routing: routing, version: version)
        return conn.databaseConnection(to: .elasticsearch).flatMap { conn in
            let body: Data
            do {
                body = try conn.encoder.encode(self)
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
    ///   - id: The document id
    ///   - routing: Routing information
    ///   - version: Version information
    /// - Returns: A Future IndexResponse
    public func delete(
        on conn: DatabaseConnectable,
        id: String,
        routing: String? = nil,
        version: Int? = nil
        ) -> Future<IndexResponse>{
        let url = ElasticsearchClient.generateURL(path: "/\(Self.indexName)/\(Self.typeName)/\(id)", routing: routing, version: version)
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
