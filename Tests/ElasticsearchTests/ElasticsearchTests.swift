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
    static var elasticsearchIndex: String {
        return "test"
    }
    
    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
    
    init(fromElasticsearchResponse response: ElasticsearchDocResponse) {
        id = response.id
        name = response.source["name"] as! String
        number = response.source["number"] as! Int
    }

    func toElasticsearchJSON() -> [String: Codable] {
        return [
            "name": name,
            "number": number
        ]
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
            .settings(index: ElasticsearchIndexSettings(shards: 3, replicas: 2))
            .create(client: es).wait()
        
        ElasticsearchModelRegistry.registerModel(model: TestModel.self, toIndex: "test")
        
        var indexDoc: TestModel = TestModel(name: "bar", number: 26)
        let response = try indexDoc.save(client: es).wait()
        indexDoc.id = response.id
        print(indexDoc)
        
        var fetchedDoc: TestModel = try TestModel.get(indexDoc.id!, client: es).wait()
        print(fetchedDoc)
        
        fetchedDoc.name = "baz"
        try fetchedDoc.save(fetchedDoc.id!, client: es).wait()
        
        fetchedDoc = try TestModel.get(fetchedDoc.id!, client: es).wait()
        print(fetchedDoc)
        
        try fetchedDoc.delete(fetchedDoc.id!, client: es).wait()
        
        try ElasticsearchMapping.delete(indexName: "test", client: es).wait()

    }
    
    static var allTests = [
        ("testCRUD", testCRUD),
    ]
}
