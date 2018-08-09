import XCTest
import Elasticsearch
import Vapor

final class VaporIntegrationTests: XCTestCase {
    func testBootSequence() throws {
        var services = Services.default()

        var config = ElasticsearchClientConfig()
        config.hostname = "localhost"
        config.port = 9200
        config.enableKeyedCache = true
        config.keyedCacheIndexName = "vapor_keyed_cache_3"
        
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
