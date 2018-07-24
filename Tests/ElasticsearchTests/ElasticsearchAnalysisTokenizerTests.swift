import XCTest
@testable import Elasticsearch

final class ElasticsearchAnalysisTokenizerTests: XCTestCase {
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
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"standard"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer()))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testStandardCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"test_std":{"type":"standard","max_token_length":5}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"test_std"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: StandardTokenizer(name: "test_std", maxTokenLength: 5)))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testLetterBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"letter"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: LetterTokenizer()))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testLowercaseBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"lowercase"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: LowercaseTokenizer()))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testWhitespaceBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"whitespace"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: WhitespaceTokenizer()))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testWhitespaceCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"short_ws":{"type":"whitespace","max_token_length":5}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"short_ws"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: WhitespaceTokenizer(name: "short_ws", maxTokenLength: 5)))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testUAXURLEmailBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"uax_url_email"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: UAXURLEmailTokenizer()))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testUAXURLEmailCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"short_ws":{"type":"uax_url_email","max_token_length":5}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"short_ws"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: UAXURLEmailTokenizer(name: "short_ws", maxTokenLength: 5)))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testClassicBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"classic"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: ClassicTokenizer()))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testClassicCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"short_ws":{"type":"classic","max_token_length":5}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"short_ws"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: ClassicTokenizer(name: "short_ws", maxTokenLength: 5)))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testThaiBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"thai"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: ThaiTokenizer()))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testNGramCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"ng":{"min_gram":1,"max_gram":5,"type":"ngram","token_chars":["punctuation"]}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"ng"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: NGramTokenizer(name: "ng", minGram: 1, maxGram: 5, tokenChars: [.punctuation])))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testEdgeNGramCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"ng":{"min_gram":1,"max_gram":5,"type":"edge_ngram","token_chars":["punctuation"]}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"ng"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: EdgeNGramTokenizer(name: "ng", minGram: 1, maxGram: 5, tokenChars: [.punctuation])))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testKeywordBuiltin_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"keyword"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: KeywordTokenizer()))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testKeywordCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"short_ws":{"type":"keyword","buffer_size":100}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"short_ws"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: KeywordTokenizer(name: "short_ws", bufferSize: 100)))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testPatternCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"short_ws":{"type":"pattern","pattern":"foo","flags":"CASE_INSENSITIVE|COMMENTS"}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"short_ws"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: PatternTokenizer(name: "short_ws", pattern:"foo", flags:"CASE_INSENSITIVE|COMMENTS")))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testSimplePatternCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"short_ws":{"type":"simple_pattern","pattern":"foo"}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"short_ws"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: SimplePatternTokenizer(name: "short_ws", pattern:"foo")))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testSimplePatternSplitCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"short_ws":{"type":"simple_pattern_split","pattern":"foo"}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"short_ws"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: SimplePatternSplitTokenizer(name: "short_ws", pattern:"foo")))
        let index = es.configureIndex(name: "test").property(key: "foo", type: map)
        
        let encoded = try encoder.encodeToString(index)
        XCTAssertEqual(json, encoded)
    }
    
    func testPathHierarchyCustom_encodesCorrectly() throws {
        let es = try ElasticsearchClient.makeTest()
        defer { es.close() }
        
        let json = """
        {"settings":{"analysis":{"tokenizer":{"short_ws":{"type":"path_hierarchy","delimiter":","}},"analyzer":{"test_analyzer":{"type":"custom","tokenizer":"short_ws"}}}},"mappings":{"_doc":{"properties":{"foo":{"type":"text","analyzer":"test_analyzer"}},"enabled":true,"dynamic":false,"_meta":{"private":{"serialVersion":1,"propertiesHash":""}}}}}
        """
        
        let map = MapText(analyzer: CustomAnalyzer(name: "test_analyzer", tokenizer: PathHierarchyTokenizer(name: "short_ws", delimiter:",")))
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
        ("testLetterBuiltin_encodesCorrectly",              testLetterBuiltin_encodesCorrectly),
        ("testLowercaseBuiltin_encodesCorrectly",           testLowercaseBuiltin_encodesCorrectly),
        ("testWhitespaceBuiltin_encodesCorrectly",          testWhitespaceBuiltin_encodesCorrectly),
        ("testWhitespaceCustom_encodesCorrectly",           testWhitespaceCustom_encodesCorrectly),
        ("testUAXURLEmailBuiltin_encodesCorrectly",         testUAXURLEmailBuiltin_encodesCorrectly),
        ("testUAXURLEmailCustom_encodesCorrectly",          testUAXURLEmailCustom_encodesCorrectly),
        ("testClassicBuiltin_encodesCorrectly",             testClassicBuiltin_encodesCorrectly),
        ("testClassicCustom_encodesCorrectly",              testClassicCustom_encodesCorrectly),
        ("testThaiBuiltin_encodesCorrectly",                testThaiBuiltin_encodesCorrectly),
        ("testNGramCustom_encodesCorrectly",                testNGramCustom_encodesCorrectly),
        ("testEdgeNGramCustom_encodesCorrectly",            testEdgeNGramCustom_encodesCorrectly),
        ("testKeywordBuiltin_encodesCorrectly",             testKeywordBuiltin_encodesCorrectly),
        ("testKeywordCustom_encodesCorrectly",              testKeywordCustom_encodesCorrectly),
        ("testPatternCustom_encodesCorrectly",              testPatternCustom_encodesCorrectly),
        ("testSimplePatternCustom_encodesCorrectly",        testSimplePatternCustom_encodesCorrectly),
        ("testSimplePatternSplitCustom_encodesCorrectly",   testSimplePatternSplitCustom_encodesCorrectly),
        ("testPathHierarchyCustom_encodesCorrectly",        testPathHierarchyCustom_encodesCorrectly),
        
        ("testLinuxTestSuiteIncludesAllTests",              testLinuxTestSuiteIncludesAllTests)
    ]
}
