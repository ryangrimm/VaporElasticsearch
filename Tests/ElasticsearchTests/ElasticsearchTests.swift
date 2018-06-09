import XCTest
@testable import Elasticsearch


extension ElasticsearchClient {
    /// Creates a test event loop and Elasticsearch client.
    static func makeTest() throws -> ElasticsearchClient {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let client = try ElasticsearchClient.connect(
            hostname: "localhost",
            port: 9200,
            on: group
        ) { error in
            XCTFail("\(error)")
            }.wait()
        return client
    }
}

struct TestModel: ElasticsearchModel {    
    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }

    var id: String?
    var name: String
    var number: Int
}

final class ElasticsearchTests: XCTestCase {
    let defaultTimeout = 2.0
    func testCRUD() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }

        try ElasticsearchMapping(indexName: "test")
            .property(key: "name", type: ESTypeText())
            .property(key: "number", type: ESTypeInteger())
            .alias(name: "testalias")
            .settings(index: ElasticsearchIndexSettingsIndex(shards: 3, replicas: 2))
            .create(client: es).wait()
        
        let mapping = try ElasticsearchMapping.fetch(indexName: "test", client: es).wait()
        print(mapping)
        
        ElasticsearchModelRegistry.registerModel(model: TestModel.self, toIndex: "test")
        
        var indexDoc: TestModel = TestModel(name: "bar", number: 26)
        var response = try es.index(doc: indexDoc, index: "test").wait()
        indexDoc.id = response.id

        
        var fetchedDoc = try es.get(decodeTo: TestModel.self, index: "test", id: indexDoc.id!).wait()
        print(fetchedDoc)
        
        fetchedDoc.source.name = "baz"
        response = try es.index(doc: fetchedDoc.source, index: "test").wait()
        
        fetchedDoc = try es.get(decodeTo: TestModel.self, index: "test", id: fetchedDoc.id).wait()
        print(fetchedDoc)
        
        let query = QueryContainer(
            Query(
                MatchAll()
            )
        )
        
        sleep(2)
        
        let searchResults = try es.search(decodeTo: TestModel.self, index: "test", query: query).wait()
        print(searchResults)
        
        try es.delete(index: "test", id: fetchedDoc.id)
        
        try ElasticsearchMapping.delete(indexName: "test", client: es).wait()
    }
    
    static var allTests = [
        ("testCRUD", testCRUD),
    ]
}
