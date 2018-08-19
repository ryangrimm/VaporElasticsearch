import XCTest
import Elasticsearch
import Vapor
//@testable import Elasticsearch

struct MyIndex: ElasticsearchModel, Reflectable {
    static let indexName = "test_21"
    
    var fooD: [ModelText] = ["try"]
    var bar: ModelDouble? = nil
    
    /*
    let user = MapObject() { properties in
        properties.property(key: "id", type: ModelInteger.Mapping())
    }
    let comment = MapNested() { properties in
        properties.property(key: "rant", type: ModelText.Mapping())
    }
 */
}

struct User: Reflectable, Decodable {
    let indexName = "test_20"

    var id: UUID?
    var name: ModelText
}

final class VaporIntegrationTests: XCTestCase {
    
    func testBootSequence() throws {
        var services = Services.default()

        var config = ElasticsearchClientConfig()
        config.hostname = "localhost"
        config.port = 9200
        config.enableKeyedCache = true
        
        config.register(model: MyIndex.self)
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
