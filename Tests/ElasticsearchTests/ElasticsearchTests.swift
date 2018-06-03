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


final class ElasticsearchTests: XCTestCase {
    let defaultTimeout = 2.0
    func testCRUD() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let doc :[String: String] = ["name": "foo"]
        let response = try es.index(doc: doc, index: "test", id: "foo").wait()
        print(response)
    }

    static var allTests = [
        ("testCRUD", testCRUD),
    ]
}
