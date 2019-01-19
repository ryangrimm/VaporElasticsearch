import Foundation

/**
 A query that matches documents matching boolean combinations of other queries.
 The bool query maps to Lucene BooleanQuery. It is built using one or more
 boolean clauses, each clause with a typed occurrence.

 [More Information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html)
 */
public struct BoolQuery: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.boolQuery

    public let must: [QueryElement]?
    public let should: [QueryElement]?
    public let mustNot: [QueryElement]?
    public let filter: [QueryElement]?
    public var minimumShouldMatch: Int?
    public var boost: Decimal?

    public init(
        must: [QueryElement]? = nil,
        should: [QueryElement]? = nil,
        mustNot: [QueryElement]? = nil,
        filter: [QueryElement]? = nil,
        minimumShouldMatch: Int? = nil,
        boost: Decimal? = nil
    ) {
        self.must = must
        self.should = should
        self.mustNot = mustNot
        self.filter = filter
        self.minimumShouldMatch = minimumShouldMatch
        self.boost = boost
    }
  
  public init(fromBoolQueryElements elements: BoolQueryElements) {
    self.must = elements.musts
    self.should = elements.shoulds
    self.mustNot = elements.mustNots
    self.filter = elements.filters
    self.minimumShouldMatch = elements.minimumShouldMatch
    self.boost = elements.boost
  }

    enum CodingKeys: String, CodingKey {
        case must
        case should
        case mustNot = "must_not"
        case filter
        case minimumShouldMatch = "minimum_should_match"
        case boost
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if must != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .must)
            for query in must! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: type(of: query).typeKey.rawValue)!)
            }
        }
        if should != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .should)
            for query in should! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: type(of: query).typeKey.rawValue)!)
            }
        }
        if mustNot != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .mustNot)
            for query in mustNot! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: type(of: query).typeKey.rawValue)!)
            }
        }
        if filter != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .filter)
            for query in filter! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: type(of: query).typeKey.rawValue)!)
            }
        }
        
        try container.encodeIfPresent(minimumShouldMatch, forKey: .minimumShouldMatch)
        try container.encodeIfPresent(boost, forKey: .boost)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        var must: [QueryElement]? = nil
        var should: [QueryElement]? = nil
        var mustNot: [QueryElement]? = nil
        var filter: [QueryElement]? = nil
        
        let container = try decoder.container(keyedBy: DynamicKey.self)
        for key in container.allKeys {
            switch (key.stringValue) {
            case "must":
                var queries = [QueryElement]()
                var rawQueries = try container.nestedUnkeyedContainer(forKey: key)
                while (!rawQueries.isAtEnd) {
                    let queryDecoder = try rawQueries.superDecoder()
                    let query = try AnyQueryElement(from: queryDecoder)
                    queries.append(query.base)
                }
                must = queries
            case "should":
                var queries = [QueryElement]()
                var rawQueries = try container.nestedUnkeyedContainer(forKey: key)
                while (!rawQueries.isAtEnd) {
                    let queryDecoder = try rawQueries.superDecoder()
                    let query = try AnyQueryElement(from: queryDecoder)
                    queries.append(query.base)
                }
                should = queries
            case "must_not":
                var queries = [QueryElement]()
                var rawQueries = try container.nestedUnkeyedContainer(forKey: key)
                while (!rawQueries.isAtEnd) {
                    let queryDecoder = try rawQueries.superDecoder()
                    let query = try AnyQueryElement(from: queryDecoder)
                    queries.append(query.base)
                }
                mustNot = queries
            case "filter":
                var queries = [QueryElement]()
                var rawQueries = try container.nestedUnkeyedContainer(forKey: key)
                while (!rawQueries.isAtEnd) {
                    let queryDecoder = try rawQueries.superDecoder()
                    let query = try AnyQueryElement(from: queryDecoder)
                    queries.append(query.base)
                }
                filter = queries
            case "minimum_should_match":
                self.minimumShouldMatch = try container.decode(Int.self, forKey: key)
            case "boost":
                self.boost = try container.decode(Decimal.self, forKey: key)
            default:
                continue
            }
        }
        
        self.must = must
        self.should = should
        self.mustNot = mustNot
        self.filter = filter
    }
}

// [More Information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html)
// Useful for creating bool queries in query-builder-functions
public struct BoolQueryElements {
  /// :nodoc:
  
  public var musts: [QueryElement]
  public var shoulds: [QueryElement]
  public var mustNots: [QueryElement]
  public var filters: [QueryElement]
  public var minimumShouldMatch: Int?
  public var boost: Decimal?
  
  public init(
    must: [QueryElement]? = nil,
    should: [QueryElement]? = nil,
    mustNot: [QueryElement]? = nil,
    filter: [QueryElement]? = nil,
    minimumShouldMatch: Int? = nil,
    boost: Decimal? = nil
    ) {
    self.musts = must ?? [QueryElement]()
    self.shoulds = should ?? [QueryElement]()
    self.mustNots = mustNot ?? [QueryElement]()
    self.filters = filter ?? [QueryElement]()
    self.minimumShouldMatch = minimumShouldMatch
    self.boost = boost
  }
  
}

