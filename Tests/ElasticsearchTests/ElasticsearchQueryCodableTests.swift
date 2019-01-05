import XCTest
@testable import Elasticsearch

final class ElasticsearchQueryCodableTests: XCTestCase {
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!

    override func setUp() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }

    func testAvgAggregation_encodesCorrectly() throws {
        let json = """
        {"aggs":{"foo":{"avg":{"field":"bar","missing":5}}},"size":0,"from":0}
        """
        let queryContainer = SearchContainer(aggs: [AvgAggregation(name: "foo", field: "bar", missing: 5)])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }

    func testCardinalityAggregation_encodesCorrectly() throws {
        let json = """
        {"aggs":{"foo":{"cardinality":{"field":"bar"}}},"size":0,"from":0}
        """
        let queryContainer = SearchContainer(aggs: [CardinalityAggregation(name: "foo", field: "bar")])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }

    func testExtendedStatsAggregation_encodesCorrectly() throws {
        let json = """
        {"aggs":{"foo":{"extended_stats":{"field":"bar"}}},"size":0,"from":0}
        """
        let queryContainer = SearchContainer(aggs: [ExtendedStatsAggregation(name: "foo", field: "bar")])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }

    func testGeoBoundsAggregation_encodesCorrectly() throws {
        let json = """
        {"aggs":{"foo":{"geo_bounds":{"field":"bar"}}},"size":0,"from":0}
        """
        let queryContainer = SearchContainer(aggs: [GeoBoundsAggregation(name: "foo", field: "bar")])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }

    func testGeoCentroidAggregation_encodesCorrectly() throws {
        let json = """
        {"aggs":{"foo":{"geo_centroid":{"field":"bar"}}},"size":0,"from":0}
        """
        let queryContainer = SearchContainer(aggs: [GeoCentroidAggregation(name: "foo", field: "bar")])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }

    func testMaxAggregation_encodesCorrectly() throws {
        let json = """
        {"aggs":{"foo":{"max":{"field":"bar"}}},"size":0,"from":0}
        """
        let queryContainer = SearchContainer(aggs: [MaxAggregation(name: "foo", field: "bar")])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }

    func testMinAggregation_encodesCorrectly() throws {
        let json = """
        {"aggs":{"foo":{"min":{"field":"bar"}}},"size":0,"from":0}
        """
        let queryContainer = SearchContainer(aggs: [MinAggregation(name: "foo", field: "bar")])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }

    func testTermsAggregation_encodesCorrectly() throws {
        let json = """
        {"aggs":{"foo":{"terms":{"field":"bar"}}},"size":0,"from":0}
        """
        let queryContainer = SearchContainer(aggs: [TermsAggregation(name: "foo", field: "bar")])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }

    func testQueryContainer_encodesCorrectly() throws {
        let json = """
        {"size":10,"query":{"match":{"title":{"query":"Recipes with pasta or spaghetti","operator":"and"}}},"aggs":{"foo":{"avg":{"field":"bar","missing":5}}},"from":0}
        """
        let match = Match(field: "title", value: "Recipes with pasta or spaghetti", operator: .and)
        let query = Query(match)
        let queryContainer = SearchContainer(query, aggs: [AvgAggregation(name: "foo", field: "bar", missing: 5)])
        let encoded = try encoder.encodeToString(queryContainer)

        XCTAssertEqual(json, encoded)
    }
    
    func testNestedQuery_encodesInQueryCorrectly() throws {
        let json = """
        {"nested":{"path":"variants","score_mode":"avg","query":{"bool":{"must":[{"match":{"variants.package_unit":{"query":"g"}}},{"range":{"variants.package_price":{"gt":5}}}]}}}}
        """
        let innerQuery = BoolQuery(must: [Match(field: "variants.package_unit", value: "g"),
                                          Range(field: "variants.package_price",
                                                greaterThanOrEqualTo: nil,
                                                greaterThan: 5,
                                                lesserThanOrEqualTo: nil,
                                                lesserThan: nil,
                                                boost: nil)],
                                   should: nil,
                                   mustNot: nil,
                                   filter: nil,
                                   minimumShouldMatch: nil,
                                   boost: nil)
        
        let nested = Nested(path: "variants",
                            scoreMode: "avg",
                            query:  innerQuery)
        
        let query = Query(nested)
        let encoded = try encoder.encodeToString(query)
        
         XCTAssertEqual(json, encoded)
        
        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        
        XCTAssertEqual(json, encodedAgain)
        
    }
    
    func testFieldValueFactor_encodesCorrectly() throws {
        let json = """
        {"missing":1,"factor":1.2,"field":"sort_order","modifier":"none"}
        """
        let fieldValueFactor = FieldValueFactor(field: "sort_order",
                                                factor: 1.2,
                                                modifier: "none",
                                                missing:1)
        let encoded = try encoder.encodeToString(fieldValueFactor)
        
         XCTAssertEqual(json, encoded)
    }
    
    func testGaussScoreFunction_encodesCorrectly() throws {
        let json = """
        {"date":{"scale":"10d","offset":"5d","origin":"2013-09-17","decay":0.5}}
        """
        
        let gauss = Gauss(field: "date",
                          origin: "2013-09-17",
                          offset: "5d",
                          decay: 0.5,
                          scale: "10d")
        
        let encoded = try encoder.encodeToString(gauss)
        XCTAssertEqual(json, encoded)
    }
    
    func testFunctionScoreQuery_withScriptScore_encodesInQueryCorrectly() throws {
        let json = """
        {"function_score":{"functions":[{"script_score":{"script":{"lang":"painless","source":"_score * doc['id'].value"}}}],"query":{"match_all":{}},"score_mode":"sum","boost":10,"max_boost":100}}
        """
        
        
        let script = Script(lang: "painless", source: "_score * doc['id'].value")
        let functionScore = FunctionScore(
            query: MatchAll(),
            boost: 10,
            functions: [ScriptScore(script: script)],
            maxBoost: 100,
            scoreMode: "sum",
            boostMode: "multiply",
            minScore: 1)
        
        let query = Query(functionScore)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
        
        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)

        XCTAssertEqual(json, encodedAgain)
    }
    
    func testFacetedSearchQuery_encodesCorrectly() throws {
        let json = """
        {"function_score":{"functions":[{"gauss":{"location":{"scale":"10mi","offset":"1mi","origin":"47.4,-122.22","decay":0.5}}},{"field_value_factor":{"field":"scores.stock","missing":0}},{"field_value_factor":{"field":"scores.random","factor":0.1,"missing":0}}],"query":{"match_all":{}},"score_mode":"avg","boost":1}}
        """
        
        let functionScoreQuery =
            FunctionScore(
                query: MatchAll(),
                boost: 1,
                functions: [
                    Gauss(field: "location",
                          origin: "47.4,-122.22",
                          offset: "1mi",
                          decay: 0.5,
                          scale: "10mi"),
                    FieldValueFactor(field: "scores.stock",
                                     factor: nil,
                                     modifier: nil,
                                     missing: 0),
                    FieldValueFactor(field: "scores.random",
                                     factor: 0.1,
                                     modifier: nil,
                                     missing: 0)
                ],
                maxBoost: nil,
                scoreMode: "avg",
                boostMode: nil,
                minScore: nil)
        
        let query = Query(functionScoreQuery)
        let encoded = try encoder.encodeToString(query)
        
        XCTAssertEqual(json, encoded)
        
        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)

        XCTAssertEqual(json, encodedAgain)
        
    }
        
        
    func testMatchAll_encodesInQueryCorrectly() throws {
        let json = """
        {"match_all":{}}
        """
        let matchAll = MatchAll()
        let query = Query(matchAll)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testMatchNone_encodesInQueryCorrectly() throws {
        let json = """
        {"match_none":{}}
        """
        let matchNone = MatchNone()
        let query = Query(matchNone)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testMatch_encodesInQueryCorrectly() throws {
        let json = """
        {"match":{"title":{"query":"Recipes with pasta or spaghetti","operator":"and"}}}
        """
        let match = Match(field: "title", value: "Recipes with pasta or spaghetti", operator: .and)
        let query = Query(match)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testMatchPhrase_encodesInQueryCorrectly() throws {
        let json = """
        {"match_phrase":{"title":{"query":"puttanesca spaghetti"}}}
        """
        let matchPhrase = MatchPhrase(field: "title", query: "puttanesca spaghetti")
        let query = Query(matchPhrase)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testMultiMatch_encodesInQueryCorrectly() throws {
        let json = """
        {"multi_match":{"fields":["title","description"],"query":"pasta","type":"cross_fields","tie_breaker":0.3}}
        """
        let multiMatch = MultiMatch(value: "pasta", fields: ["title", "description"], type: .crossFields, tieBreaker: 0.3)
        let query = Query(multiMatch)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testTerm_encodesInQueryCorrectly() throws {
        let json = """
        {"term":{"description":{"value":"drinking","boost":2}}}
        """
        let term = Term(field: "description", value: "drinking", boost: 2.0)
        let query = Query(term)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testTerms_encodesInQueryCorrectly() throws {
        let json = """
        {"terms":{"tags.keyword":["Soup","Cake"]}}
        """
        let terms = Terms(field: "tags.keyword", values: ["Soup", "Cake"])
        let query = Query(terms)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testRange_encodesInQueryCorrectly() throws {
        let json = """
        {"range":{"in_stock":{"gte":1,"lte":5}}}
        """
        let range = Range(field: "in_stock", greaterThanOrEqualTo: 1, lesserThanOrEqualTo: 5)
        let query = Query(range)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testRange_encodesInQueryCorrectly_date() throws {
        let json = """
        {"range":{"created":{"gt":"01-01-2010","format":"dd-MM-yyyy","lt":"31-12-2010"}}}
        """
        let range = Range(field: "created", greaterThan: "01-01-2010", lesserThan: "31-12-2010", format: "dd-MM-yyyy")
        let query = Query(range)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testExists_encodesInQueryCorrectly() throws {
        let json = """
        {"exists":{"field":"tags"}}
        """
        let exists = Exists(field: "tags")
        let query = Query(exists)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testBool_encodesInQueryCorrectly() throws {
        let json = """
        {"bool":{"must":[{"match":{"title":{"query":"pasta"}}}]}}
        """
        let match = Match(field: "title", value: "pasta")
        // let range = Query(Range(key: "preparation_time_minutes", lesserThanOrEqualTo: 15))
        let bool = BoolQuery(must: [match])
        let query = Query(bool)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testPrefix_encodesInQueryCorrectly() throws {
        let json = """
        {"prefix":{"tags.keyword":{"value":"Vege","boost":1}}}
        """
        let prefix = Prefix(field: "tags.keyword", value: "Vege", boost: 1)
        let query = Query(prefix)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testWildcard_encodesInQueryCorrectly() throws {
        let json = """
        {"wildcard":{"tags.keyword":{"value":"Veg*ble","boost":2}}}
        """
        let wildcard = Wildcard(field: "tags.keyword", value: "Veg*ble", boost: 2)
        let query = Query(wildcard)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testRegexp_encodesInQueryCorrectly() throws {
        let json = """
        {"regexp":{"tags.keyword":{"value":"Veg[a-zA-Z]ble","boost":2.5}}}
        """
        let regexp = Regexp(field: "tags.keyword", value: "Veg[a-zA-Z]ble", boost: 2.5)
        let query = Query(regexp)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testFuzzy_encodesInQueryCorrectly() throws {
        let json = """
        {"fuzzy":{"name":{"value":"bolster","fuzziness":2}}}
        """
        let fuzzy = Fuzzy(field: "name", value: "bolster", fuzziness: 2)
        let query = Query(fuzzy)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testIDs_encodesInQueryCorrectly() throws {
        let json = """
        {"ids":{"values":["1","2","3"]}}
        """
        let ids = IDs(["1", "2", "3"])
        let query = Query(ids)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testSpanFirst_encodesInQueryCorrectly() throws {
        let json =  """
        {"span_first":{"match":{"span_term":{"user":{"term":"kimchy"}}},"end":3}}
        """

        let span  = SpanFirst(match: SpanTerm(field: "user", term: "kimchy"), end: 3)
        let query = Query(span)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testSpanNot_encodesInQueryCorrectly() throws {
        let json =  """
        {"span_not":{"include":{"span_term":{"user":{"term":"kimchy"}}},"exclude":{"span_term":{"user":{"term":"yhcmik"}}},"pre":3}}
        """

        let span  = SpanNot(include: SpanTerm(field: "user", term: "kimchy"), exclude: SpanTerm(field: "user", term: "yhcmik"), pre: 3)
        let query = Query(span)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testSpanOr_encodesInQueryCorrectly() throws {
        let json =  """
        {"span_or":{"clauses":[{"span_term":{"field":{"term":"value1"}}},{"span_term":{"field":{"term":"value2"}}}]}}
        """

        let span  = SpanOr([SpanTerm(field: "field", term: "value1"), SpanTerm(field: "field", term: "value2")])
        let query = Query(span)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testSpanNear_encodesInQueryCorrectly() throws {
        let json =  """
        {"span_near":{"clauses":[{"span_term":{"field":{"term":"value1"}}},{"span_term":{"field":{"term":"value2"}}}],"slop":10}}
        """

        let span  = SpanNear([SpanTerm(field: "field", term: "value1"), SpanTerm(field: "field", term: "value2")], slop: 10)
        let query = Query(span)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testGeoPolygon_encodesInQueryCorrectly() throws {
        let json =  """
        {"geo_polygon":{"person.location":{"points":[{"lat":40,"lon":-70},{"lat":30,"lon":-80},{"lat":20,"lon":-90}]}}}
        """

        let poly  = GeoPolygon(field: "person.location", points: [GeoPoint(lat: 40, lon: -70), GeoPoint(lat: 30, lon: -80), GeoPoint(lat: 20, lon: -90)])
        let query = Query(poly)
        let encoded = try encoder.encodeToString(query)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(query)
        let decoded = try decoder.decode(Query.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testSort_encodesInQueryCorrectly() throws {
        let json = """
        {"recipe_name":{"order":"desc"}}
        """

        let sort = Sort("recipe_name", .descending)
        let encoded = try encoder.encodeToString(sort)

        XCTAssertEqual(json, encoded)

        let toDecode = try encoder.encode(sort)
        let decoded = try decoder.decode(Sort.self, from: toDecode)
        let encodedAgain = try encoder.encodeToString(decoded)
        XCTAssertEqual(json, encodedAgain)
    }

    func testSort_encodesInSearchContainerCorrectly() throws {
        let json = """
        {"size":10,"query":{"match_all":{}},"sort":[{"recipe_name":{"order":"desc"}}],"from":0}
        """

        let matchAll = MatchAll()
        let sort = Sort("recipe_name", .descending)
        let query = Query(matchAll)
        let container = SearchContainer(query, sort: [sort])
        let encoded = try encoder.encodeToString(container)

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
        ("testAvgAggregation_encodesCorrectly",     testAvgAggregation_encodesCorrectly),
        ("testCardinalityAggregation_encodesCorrectly", testCardinalityAggregation_encodesCorrectly),
        ("testExtendedStatsAggregation_encodesCorrectly", testExtendedStatsAggregation_encodesCorrectly),
        ("testGeoBoundsAggregation_encodesCorrectly", testGeoBoundsAggregation_encodesCorrectly),
        ("testGeoCentroidAggregation_encodesCorrectly", testGeoCentroidAggregation_encodesCorrectly),
        ("testMaxAggregation_encodesCorrectly",     testMaxAggregation_encodesCorrectly),
        ("testMinAggregation_encodesCorrectly",     testMinAggregation_encodesCorrectly),
        ("testTermsAggregation_encodesCorrectly",   testTermsAggregation_encodesCorrectly),
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
        ("testSpanFirst_encodesInQueryCorrectly",   testSpanFirst_encodesInQueryCorrectly),
        ("testSpanNot_encodesInQueryCorrectly",     testSpanNot_encodesInQueryCorrectly),
        ("testSpanOr_encodesInQueryCorrectly",      testSpanOr_encodesInQueryCorrectly),
        ("testSpanNear_encodesInQueryCorrectly",    testSpanNear_encodesInQueryCorrectly),
        ("testGeoPolygon_encodesInQueryCorrectly",  testGeoPolygon_encodesInQueryCorrectly),

        ("testSort_encodesInQueryCorrectly",        testSort_encodesInQueryCorrectly),
        ("testSort_encodesInSearchContainerCorrectly", testSort_encodesInSearchContainerCorrectly),

        ("testLinuxTestSuiteIncludesAllTests",      testLinuxTestSuiteIncludesAllTests)
    ]
}
