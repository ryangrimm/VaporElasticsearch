import XCTest
import Elasticsearch

final class NormalizerTests: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!
    
    override func setUp() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    
    func testCustomNormalizer_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"normalizer":{"test_normalizer":{"type":"custom","filter":["foo","bar"]}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"keyword","normalizer":"test_normalizer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = ModelKeyword.Mapping(normalizer: CustomNormalizer(name: "test_normalizer", filter: ["foo", "bar"]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
 
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
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
        ("testCustomNormalizer_encodesCorrectly",     testCustomNormalizer_encodesCorrectly),
        
        ("testLinuxTestSuiteIncludesAllTests",      testLinuxTestSuiteIncludesAllTests)
    ]
}
