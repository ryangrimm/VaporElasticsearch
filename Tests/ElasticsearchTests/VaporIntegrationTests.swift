import XCTest
import Elasticsearch
import Vapor
//@testable import Elasticsearch

struct MyIndex: ElasticsearchIndex {
    let _indexName = "test_9"
    let _keyMap = ["foo": "foo_d"]
    
    let foo = MapText()
    let bar = MapDouble()
    let user = MapObject() { properties in
        properties.property(key: "id", type: MapInteger())
    }
    let comment = MapNested() { properties in
        properties.property(key: "rant", type: MapText())
    }
}

final class VaporIntegrationTests: XCTestCase {
    
    func testBootSequence() throws {
        var services = Services.default()

        var config = ElasticsearchClientConfig()
        config.hostname = "localhost"
        config.port = 9200
        config.enableKeyedCache = true
        config.keyedCacheIndexName = "vapor_keyed_cache_7"
        
        try services.register(MyIndex())
        try services.register(ElasticsearchProvider(config))
        
        let _ = try Application.asyncBoot(config: .default(), environment: .xcode, services: services).wait()
    }
    
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = Int(thisClass.defaultTestSuite.testCaseCount)
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
    
    static var allTests = [
        ("testBootSequence", testBootSequence),
        
        ("testLinuxTestSuiteIncludesAllTests",      testLinuxTestSuiteIncludesAllTests)
    ]
}
