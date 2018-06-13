import Foundation

public struct BoolQuery: QueryElement {
    public static var typeKey = QueryElementMap.boolQuery

    public var codingKey = "bool"

    public var must: [QueryElement]?
    public var should: [QueryElement]?
    public var mustNot: [QueryElement]?
    public var filter: [QueryElement]?
    let minimumShouldMatch: Int?
    let boost: Decimal?

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
    
    // XXX - implement
    public init(from decoder: Decoder) throws {
        self.must = nil
        self.should = nil
        self.mustNot = nil
        self.filter = nil
        self.minimumShouldMatch = nil
        self.boost = nil
    }
}
