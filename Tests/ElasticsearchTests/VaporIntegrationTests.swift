import XCTest
import Elasticsearch
import Vapor
//@testable import Elasticsearch

struct Comment: ModelObject {
    public static let allowDynamicKeys = false
    public static let enableSearching = false
    
    var text: ModelText
    var postedOn: ModelDate

}

struct MyIndex: ElasticsearchModel {
    public static var innerModelTypes: [ModelBaseObject.Type] {
        return [Comment.self]
    }
    
    static func tuneConfiguration(key: String, config: inout Mappable) {
        if key == "comments" {
            config.overrideType = MapType.nested
        }
    }

    static let indexName = "posts7"
    
    var tags = ["awesome"]
    var comments: [Comment]? = nil
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
