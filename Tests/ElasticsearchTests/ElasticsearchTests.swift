import XCTest
@testable import Elasticsearch


extension ElasticsearchClient {
    /// Creates a test event loop and Elasticsearch client.
    static func makeTest() throws -> ElasticsearchClient {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let client = try ElasticsearchClient.connect(hostname: "localhost", port: 9200, on: group) { error in
            XCTFail("\(error)")
        }.wait()
        return client
    }
}

struct TestModel: Codable, SettableID {
    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }

    var id: String?
    var name: String
    var number: Int
    
    mutating func setID(_ id: String) {
        self.id = id
    }
}

final class ElasticsearchTests: XCTestCase {
    func testIndexCreation() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        try? ElasticsearchIndex.delete(indexName: "test", client: es).wait()
        
        try ElasticsearchIndex(indexName: "test")
            .property(key: "name", type: MapText())
            .property(key: "number", type: MapInteger())
            .alias(name: "testalias")
            .settings(index: IndexSettings(shards: 3, replicas: 2))
            .create(client: es).wait()
        
        let index = try ElasticsearchIndex.fetch(indexName: "test", client: es).wait()
        XCTAssertEqual(index.aliases.count, 1, "Incorrect number of aliases")
        XCTAssertNotNil(index.aliases["testalias"], "testalias does not exist")
        XCTAssertEqual(index.settings?.index?.numberOfShards, 3, "Incorrect number of shards")
        XCTAssertEqual(index.settings?.index?.numberOfReplicas, 2, "Incorrect number of replicas")
        
        // TODO: Should test for more than just the existance of the properties
        let nameProp = index.mappings.doc.properties["name"]
        let numberProp = index.mappings.doc.properties["number"]
        XCTAssertNotNil(nameProp, "Could not find name property")
        XCTAssertNotNil(numberProp, "Could not find number property")
        
        try ElasticsearchIndex.delete(indexName: "test", client: es).wait()
    }
    
    func testCRUD() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        try? ElasticsearchIndex.delete(indexName: "test", client: es).wait()

        try ElasticsearchIndex(indexName: "test")
            .property(key: "name", type: MapText())
            .property(key: "number", type: MapInteger())
            .alias(name: "testalias")
            .settings(index: IndexSettings(shards: 3, replicas: 2))
            .create(client: es).wait()
        
        var indexDoc: TestModel = TestModel(name: "bar", number: 26)
        var response = try es.index(doc: indexDoc, index: "test").wait()
        indexDoc.id = response.id

        
        var fetchedDoc = try es.get(decodeTo: TestModel.self, index: "test", id: indexDoc.id!).wait()
        XCTAssertEqual(indexDoc.name, fetchedDoc.source.name, "Saved and fetched names do not match")
        XCTAssertEqual(indexDoc.number, fetchedDoc.source.number, "Saved and fetched numbers do not match")

        fetchedDoc.source.name = "baz"
        response = try es.index(doc: fetchedDoc.source, index: "test", id: fetchedDoc.id).wait()
        
        sleep(2)

        fetchedDoc = try es.get(decodeTo: TestModel.self, index: "test", id: fetchedDoc.id).wait()
        XCTAssertEqual(fetchedDoc.source.name, "baz", "Updated name does not match")

        sleep(2)

        let query = SearchContainer(
            Query(
                MatchAll()
            )
        )

        let searchResults = try es.search(decodeTo: TestModel.self, index: "test", query: query).wait()
        XCTAssertEqual(searchResults.hits!.total, 1, "Should have found one result")
        XCTAssertEqual(searchResults.hits!.hits.first?.source.name, fetchedDoc.source.name, "Did not fetch correct document")
        
        let _ = try es.delete(index: "test", id: fetchedDoc.id)
    
        try ElasticsearchIndex.delete(indexName: "test", client: es).wait()
    }
    
    static var allTests = [
        ("testIndexCreation", testIndexCreation),
        ("testCRUD", testCRUD)
    ]
}
