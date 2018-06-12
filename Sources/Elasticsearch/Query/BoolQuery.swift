import Foundation

public struct BoolQuery: QueryElement {
    public static var typeKey = QueryElementMap.boolQuery

    public var codingKey = "bool"

    public var must: [AnyQueryElement]?
    public var should: [AnyQueryElement]?
    public var mustNot: [AnyQueryElement]?
    public var filter: [AnyQueryElement]?
    let minimumShouldMatch: Int?
    let boost: Decimal?

    public init(
        must: [AnyQueryElement]? = nil,
        should: [AnyQueryElement]? = nil,
        mustNot: [AnyQueryElement]? = nil,
        filter: [AnyQueryElement]? = nil,
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
                try queryContainer.encode(query, forKey: DynamicKey(stringValue: query.base.codingKey)!)
            }
        }
        if should != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .should)
            for query in should! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(query, forKey: DynamicKey(stringValue: query.base.codingKey)!)
            }
        }
        if mustNot != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .mustNot)
            for query in mustNot! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(query, forKey: DynamicKey(stringValue: query.base.codingKey)!)
            }
        }
        if filter != nil {
            var arrayContainer = container.nestedUnkeyedContainer(forKey: .filter)
            for query in filter! {
                var queryContainer = arrayContainer.nestedContainer(keyedBy: DynamicKey.self)
                try queryContainer.encode(query, forKey: DynamicKey(stringValue: query.base.codingKey)!)
            }
        }
        
        try container.encodeIfPresent(minimumShouldMatch, forKey: .minimumShouldMatch)
        try container.encodeIfPresent(boost, forKey: .boost)
    }
}
