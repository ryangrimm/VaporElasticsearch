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
    init(name: String) {
        self.name = name
    }
    
    init(fromElasticsearchResponse response: ElasticsearchDocResponse) {
        id = response.id
        name = response.source["name"] as! String
    }

    func toElasticsearchJSON() -> [String: Codable] {
        return [
            "name": name
        ]
    }

    var id: String?
    var name: String
}

final class ElasticsearchTests: XCTestCase {
    let defaultTimeout = 2.0
    func testCRUD() throws {        
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let indexDoc = TestModel(name: "bar")
        let indexRes = try es.index(doc: indexDoc, index: "test", id: "foo")
        print(indexRes)
        
        let getRes: ElasticsearchDocResponse = try es.get(index: "test", id: "foo").wait()
        let model = TestModel(fromElasticsearchResponse: getRes)
        print(getRes.source)
        print(model)
    }
    
    static var allTests = [
        ("testCRUD", testCRUD),
    ]
}
