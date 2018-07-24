import Foundation
import XCTest
@testable import Elasticsearch

extension JSONEncoder {
    func encodeToString<T>(_ value: T) throws -> String where T : Encodable {
        let data = try self.encode(value)
        
        return String(data: data, encoding: .utf8)!
    }
}

extension ElasticsearchClient {
    /// Creates a test event loop and Elasticsearch client.
    static func makeTest() throws -> ElasticsearchClient {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let config = ElasticsearchClientConfig()
        let client = try ElasticsearchClient.connect(config: config, on: group) { error in
            XCTFail("\(error)")
            }.wait()
        return client
    }
}
