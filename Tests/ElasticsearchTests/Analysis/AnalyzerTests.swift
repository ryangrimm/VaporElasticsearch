import XCTest
import Elasticsearch

final class AnalyzerTests: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!
    
    override func setUp() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    
    
    func encodeBuilder() {
        
    }
    
    func testStandardBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"standard"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: StandardAnalyzer())
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testStandardCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"ana":{"type":"standard","stopwords":["foo","bar"],"max_token_length":10}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"ana"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: StandardAnalyzer(name: "ana", stopwords: ["foo", "bar"], maxTokenLength: 10))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testFingerprintCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"ana":{"type":"fingerprint","separator":":","stopwords":["foo","bar"]}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"ana"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: FingerprintAnalyzer(name: "ana", separator: ":", stopwords: ["foo", "bar"]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    
    func testStopCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"ana":{"type":"stop","stopwords":["foo","bar"]}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"ana"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: StopAnalyzer(name: "ana", stopwords: ["foo", "bar"]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testKeywordBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"keyword"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: KeywordAnalyzer())
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testPatternCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"ana":{"pattern":"bar","flags":"CASE_INSENSITIVE|COMMENTS","lowercase":true,"stopwords":["_english_"],"type":"pattern"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"ana"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: PatternAnalyzer(name: "ana", pattern: "bar", flags: "CASE_INSENSITIVE|COMMENTS", lowercase: true, stopwords: ["_english_"]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testSimpleBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"simple"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: SimpleAnalyzer())
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testWhitespaceBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"whitespace"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: WhitespaceAnalyzer())
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
        ("testStandardBuiltin_encodesCorrectly",            testStandardBuiltin_encodesCorrectly),
        ("testStandardCustom_encodesCorrectly",             testStandardCustom_encodesCorrectly),
        ("testFingerprintCustom_encodesCorrectly",          testFingerprintCustom_encodesCorrectly),
        ("testStopCustom_encodesCorrectly",                 testStopCustom_encodesCorrectly),
        ("testKeywordBuiltin_encodesCorrectly",             testKeywordBuiltin_encodesCorrectly),
        ("testPatternCustom_encodesCorrectly",              testPatternCustom_encodesCorrectly),
        ("testSimpleBuiltin_encodesCorrectly",              testSimpleBuiltin_encodesCorrectly),
        ("testWhitespaceBuiltin_encodesCorrectly",          testWhitespaceBuiltin_encodesCorrectly),
        
        ("testLinuxTestSuiteIncludesAllTests",              testLinuxTestSuiteIncludesAllTests)
    ]
}
