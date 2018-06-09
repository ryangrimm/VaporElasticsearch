import Foundation

public struct BoolQuery<U: QueryElement>: QueryElement, CompoundQuery {
    public typealias QueryType = BoolQuery
    public typealias SubQueryType = QueryElement
    public var codingKey = "bool"

    public var must: [Query<U>]?
    public var should: [Query<U>]?
    public var mustNot: [Query<U>]?
    public var filter: [Query<U>]?
    let minimumShouldMatch: Int?
    let boost: Decimal?

    public init(
        must: [Query<U>]? = nil,
        should: [Query<U>]? = nil,
        mustNot: [Query<U>]? = nil,
        filter: [Query<U>]? = nil,
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
}
