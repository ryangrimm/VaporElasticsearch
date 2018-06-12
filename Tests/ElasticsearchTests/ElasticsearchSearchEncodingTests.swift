import XCTest
@testable import Elasticsearch

final class ElasticsearchSearchEncodingTests: XCTestCase {
    var encoder: JSONEncoder!
    
    override func setUp() {
        encoder = JSONEncoder()
    }
    
    func testQueryContainer_encodesCorrectly() throws {
        let json = """
        {"query":{"match":{"title":{"query":"Recipes with pasta or spaghetti","operator":"and"}}}}
        """
        let match = Match(key: "title", value: "Recipes with pasta or spaghetti", operator: "and")
        let query = Query(match)
        let queryContainer = QueryContainer(query)
        let encoded = try encoder.encodeToString(queryContainer)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testMatchAll_encodesInQueryCorrectly() throws {
        let json = """
        {"match_all":{}}
        """
        let matchAll = MatchAll()
        let query = Query(matchAll)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testMatchNone_encodesInQueryCorrectly() throws {
        let json = """
        {"match_none":{}}
        """
        let matchNone = MatchNone()
        let query = Query(matchNone)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testMatch_encodesInQueryCorrectly() throws {
        let json = """
        {"match":{"title":{"query":"Recipes with pasta or spaghetti","operator":"and"}}}
        """
        let match = Match(key: "title", value: "Recipes with pasta or spaghetti", operator: "and")
        let query = Query(match)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testMatchPhrase_encodesInQueryCorrectly() throws {
        let json = """
        {"match_phrase":{"title":"puttanesca spaghetti"}}
        """
        let matchPhrase = MatchPhrase(key: "title", value: "puttanesca spaghetti")
        let query = Query(matchPhrase)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testMultiMatch_encodesInQueryCorrectly() throws {
        let json = """
        {"multi_match":{"fields":["title","description"],"query":"pasta","type":"cross_fields","tie_breaker":0.3}}
        """
        let multiMatch = MultiMatch(value: "pasta", fields: ["title", "description"], type: .crossFields, tieBreaker: 0.3)
        let query = Query(multiMatch)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testTerm_encodesInQueryCorrectly() throws {
        let json = """
        {"term":{"description":{"value":"drinking","boost":2}}}
        """
        let term = Term(key: "description", value: "drinking", boost: 2.0)
        //let query = Query(term: term)
        let query = Query(term)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testTerms_encodesInQueryCorrectly() throws {
        let json = """
        {"terms":{"tags.keyword":["Soup","Cake"]}}
        """
        let terms = Terms(key: "tags.keyword", values: ["Soup", "Cake"])
        let query = Query(terms)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testRange_encodesInQueryCorrectly() throws {
        let json = """
        {"range":{"in_stock":{"gte":1,"lte":5}}}
        """
        let range = Range(key: "in_stock", greaterThanOrEqualTo: 1, lesserThanOrEqualTo: 5)
        let query = Query(range)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testRange_encodesInQueryCorrectly_date() throws {
        let json = """
        {"range":{"created":{"gt":"01-01-2010","format":"dd-MM-yyyy","lt":"31-12-2010"}}}
        """
        let range = Range(key: "created", greaterThan: "01-01-2010", lesserThan: "31-12-2010", format: "dd-MM-yyyy")
        let query = Query(range)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testExists_encodesInQueryCorrectly() throws {
        let json = """
        {"exists":{"field":"tags"}}
        """
        let exists = Exists(field: "tags")
        let query = Query(exists)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testBool_encodesInQueryCorrectly() throws {
        let json = """
        {"bool":{"must":[{"match":{"title":{"query":"pasta"}}}]}}
        """
        let match = Match(key: "title", value: "pasta")
        // Multi-type queries don’t unfortunately work at the moment
        // let range = Query(Range(key: "preparation_time_minutes", lesserThanOrEqualTo: 15))
        let bool = BoolQuery(must: [match])
        let query = Query(bool)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testPrefix_encodesInQueryCorrectly() throws {
        let json = """
        {"prefix":{"tags.keyword":{"value":"Vege","boost":1}}}
        """
        let prefix = Prefix(key: "tags.keyword", value: "Vege", boost: 1)
        let query = Query(prefix)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testWildcard_encodesInQueryCorrectly() throws {
        let json = """
        {"wildcard":{"tags.keyword":{"value":"Veg*ble","boost":2}}}
        """
        let wildcard = Wildcard(key: "tags.keyword", value: "Veg*ble", boost: 2)
        let query = Query(wildcard)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testRegexp_encodesInQueryCorrectly() throws {
        let json = """
        {"regexp":{"tags.keyword":{"value":"Veg[a-zA-Z]ble","boost":2.5}}}
        """
        let regexp = Regexp(key: "tags.keyword", value: "Veg[a-zA-Z]ble", boost: 2.5)
        let query = Query(regexp)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testFuzzy_encodesInQueryCorrectly() throws {
        let json = """
        {"fuzzy":{"name":{"value":"bolster","fuzziness":2}}}
        """
        let fuzzy = Fuzzy(key: "name", value: "bolster", fuzziness: 2)
        let query = Query(fuzzy)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
    }
    
    func testIDs_encodesInQueryCorrectly() throws {
        let json = """
        {"ids":{"values":["1","2","3"]}}
        """
        let ids = IDs(["1", "2", "3"])
        let query = Query(ids)
        let encoded = try encoder.encodeToString(query)
        
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
        ("testQueryContainer_encodesCorrectly",     testQueryContainer_encodesCorrectly),
        
        ("testMatchAll_encodesInQueryCorrectly",    testMatchAll_encodesInQueryCorrectly),
        ("testMatchNone_encodesInQueryCorrectly",   testMatchNone_encodesInQueryCorrectly),
        ("testMatch_encodesInQueryCorrectly",       testMatch_encodesInQueryCorrectly),
        ("testMatchPhrase_encodesInQueryCorrectly", testMatchPhrase_encodesInQueryCorrectly),
        ("testMultiMatch_encodesInQueryCorrectly",  testMultiMatch_encodesInQueryCorrectly),
        ("testTerm_encodesInQueryCorrectly",        testTerm_encodesInQueryCorrectly),
        ("testTerms_encodesInQueryCorrectly",       testTerms_encodesInQueryCorrectly),
        
        ("testRange_encodesInQueryCorrectly",       testRange_encodesInQueryCorrectly),
        ("testRange_encodesInQueryCorrectly_date",  testRange_encodesInQueryCorrectly_date),
        
        ("testExists_encodesInQueryCorrectly",      testExists_encodesInQueryCorrectly),
        ("testBool_encodesInQueryCorrectly",        testBool_encodesInQueryCorrectly),
        ("testPrefix_encodesInQueryCorrectly",      testPrefix_encodesInQueryCorrectly),
        ("testWildcard_encodesInQueryCorrectly",    testWildcard_encodesInQueryCorrectly),
        ("testRegexp_encodesInQueryCorrectly",      testRegexp_encodesInQueryCorrectly),
        ("testFuzzy_encodesInQueryCorrectly",       testFuzzy_encodesInQueryCorrectly),
        ("testIDs_encodesInQueryCorrectly",         testIDs_encodesInQueryCorrectly),
        
        ("testLinuxTestSuiteIncludesAllTests",      testLinuxTestSuiteIncludesAllTests)
    ]
}
