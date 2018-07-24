import XCTest
@testable import Elasticsearch

final class TokenFilterTests: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!
    
    override func setUp() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    
    func testStandardBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["standard"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [StandardFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testASCIIFoldingBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["ascii_folding"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [ASCIIFoldingFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testLengthCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"filter":{"fil":{"type":"length","min":2,"max":5}},"analyzer":{"test_analyzer":{"type":"custom","filter":["fil"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [LengthFilter(name: "fil", min: 2, max: 5)]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testUppercaseBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["uppercase"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [UppercaseFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    
    func testLowercaseBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["lowercase"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [LowercaseFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testLowercaseCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"filter":{"fil":{"type":"lowercase","language":"turkish"}},"analyzer":{"test_analyzer":{"type":"custom","filter":["fil"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [LowercaseFilter(name: "fil", language: .turkish)]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testNGramCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"filter":{"fil":{"type":"nGram","max_gram":6,"min_gram":3}},"analyzer":{"test_analyzer":{"type":"custom","filter":["fil"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [NGramFilter(name: "fil", minGram: 3, maxGram: 6)]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testEdgeNGramCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"filter":{"fil":{"type":"edgeNGram","max_gram":6,"min_gram":3}},"analyzer":{"test_analyzer":{"type":"custom","filter":["fil"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [EdgeNGramFilter(name: "fil", minGram: 3, maxGram: 6)]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testPorterStemBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["porter_stem"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [PorterStemFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testKStemBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["kstem"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [KStemFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testReverseBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["reverse"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [ReverseFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testSynonymCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"filter":{"fil":{"type":"synonym","format":"solr","synonyms":["foo","bar"]}},"analyzer":{"test_analyzer":{"type":"custom","filter":["fil"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [SynonymFilter(name: "fil", synonyms: ["foo", "bar"])]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        print(encoded)
        XCTAssertEqual(json, encoded)
    }
    
    func testTrimBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["trim"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [TrimFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testClassicBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["classic"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [ClassicFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testApostropheBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["apostrophe"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [ApostropheFilter()]))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testDecimalDigitBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","filter":["decimal_digit"],"tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(), filter: [DecimalDigitFilter()]))
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
        ("testASCIIFoldingBuiltin_encodesCorrectly",        testASCIIFoldingBuiltin_encodesCorrectly),
        ("testLengthCustom_encodesCorrectly",               testLengthCustom_encodesCorrectly),
        ("testUppercaseBuiltin_encodesCorrectly",           testUppercaseBuiltin_encodesCorrectly),
        ("testLowercaseBuiltin_encodesCorrectly",           testLowercaseBuiltin_encodesCorrectly),
        ("testLowercaseCustom_encodesCorrectly",            testLowercaseCustom_encodesCorrectly),
        ("testNGramCustom_encodesCorrectly",                testNGramCustom_encodesCorrectly),
        ("testEdgeNGramCustom_encodesCorrectly",            testEdgeNGramCustom_encodesCorrectly),
        ("testPorterStemBuiltin_encodesCorrectly",          testPorterStemBuiltin_encodesCorrectly),
        ("testKStemBuiltin_encodesCorrectly",               testKStemBuiltin_encodesCorrectly),
        ("testReverseBuiltin_encodesCorrectly",             testReverseBuiltin_encodesCorrectly),
        ("testSynonymCustom_encodesCorrectly",              testSynonymCustom_encodesCorrectly),
        ("testTrimBuiltin_encodesCorrectly",                testTrimBuiltin_encodesCorrectly),
        ("testClassicBuiltin_encodesCorrectly",             testClassicBuiltin_encodesCorrectly),
        ("testApostropheBuiltin_encodesCorrectly",          testApostropheBuiltin_encodesCorrectly),
        ("testDecimalDigitBuiltin_encodesCorrectly",        testDecimalDigitBuiltin_encodesCorrectly),
        
        ("testLinuxTestSuiteIncludesAllTests",              testLinuxTestSuiteIncludesAllTests)
    ]
}
