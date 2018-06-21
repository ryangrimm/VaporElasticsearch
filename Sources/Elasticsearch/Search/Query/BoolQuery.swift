import Foundation

public struct BoolQuery: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.boolQuery

    /// :nodoc:
    public var codingKey = "bool"

    public var must: [QueryElement]?
    public var should: [QueryElement]?
    public var mustNot: [QueryElement]?
    public var filter: [QueryElement]?
    var minimumShouldMatch: Int?
    var boost: Decimal?

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
                try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: query.codingKey)!)
            }
        }
        if should != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .should)
            for query in should! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: query.codingKey)!)
            }
        }
        if mustNot != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .mustNot)
            for query in mustNot! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: query.codingKey)!)
            }
        }
        if filter != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .filter)
            for query in filter! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: query.codingKey)!)
            }
        }
        
        try container.encodeIfPresent(minimumShouldMatch, forKey: .minimumShouldMatch)
        try container.encodeIfPresent(boost, forKey: .boost)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        
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
                self.must = queries
            case "should":
                var queries = [QueryElement]()
                var rawQueries = try container.nestedUnkeyedContainer(forKey: key)
                while (!rawQueries.isAtEnd) {
                    let queryDecoder = try rawQueries.superDecoder()
                    let query = try AnyQueryElement(from: queryDecoder)
                    queries.append(query.base)
                }
                self.should = queries
            case "must_not":
                var queries = [QueryElement]()
                var rawQueries = try container.nestedUnkeyedContainer(forKey: key)
                while (!rawQueries.isAtEnd) {
                    let queryDecoder = try rawQueries.superDecoder()
                    let query = try AnyQueryElement(from: queryDecoder)
                    queries.append(query.base)
                }
                self.mustNot = queries
            case "filter":
                var queries = [QueryElement]()
                var rawQueries = try container.nestedUnkeyedContainer(forKey: key)
                while (!rawQueries.isAtEnd) {
                    let queryDecoder = try rawQueries.superDecoder()
                    let query = try AnyQueryElement(from: queryDecoder)
                    queries.append(query.base)
                }
                self.filter = queries
            case "minimum_should_match":
                self.minimumShouldMatch = try container.decode(Int.self, forKey: key)
            case "boost":
                self.boost = try container.decode(Decimal.self, forKey: key)
            default:
                continue
            }
        }
    }
}
