import XCTest
import Elasticsearch

final class CharacterFilterTests: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!
    
    override func setUp() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
  
    
    func testHTMLStripBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","char_filter":["html_strip"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), characterFilter: [HTMLStripCharacterFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testHTMLStripCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"char_filter":{"char":{"type":"html_strip","escaped_tags":["span"]}},"analyzer":{"test_analyzer":{"type":"custom","char_filter":["char"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), characterFilter: [HTMLStripCharacterFilter(name: "char", escapedTags: ["span"])]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testMappingCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"char_filter":{"char":{"type":"mapping","mappings":{"foo":"bar"}}},"analyzer":{"test_analyzer":{"type":"custom","char_filter":["char"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), characterFilter: [MappingCharacterFilter(name: "char", mappings: ["foo": "bar"])]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testPatternReplaceCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"char_filter":{"char":{"type":"pattern_replace","pattern":"foo","replacement":"bar"}},"analyzer":{"test_analyzer":{"type":"custom","char_filter":["char"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), characterFilter: [PatternReplaceCharacterFilter(name: "char", pattern: "foo", replacement: "bar")]))
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
        ("testHTMLStripBuiltin_encodesCorrectly",           testHTMLStripBuiltin_encodesCorrectly),
        ("testHTMLStripCustom_encodesCorrectly",            testHTMLStripCustom_encodesCorrectly),
        ("testMappingCustom_encodesCorrectly",              testMappingCustom_encodesCorrectly),
        ("testPatternReplaceCustom_encodesCorrectly",       testPatternReplaceCustom_encodesCorrectly),
        
        ("testLinuxTestSuiteIncludesAllTests",              testLinuxTestSuiteIncludesAllTests)
    ]
}
