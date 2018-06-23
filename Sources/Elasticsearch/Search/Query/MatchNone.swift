import Foundation

/**
 This is the inverse of the `MatchAll` query, which matches no documents.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-match-all-query.html#query-dsl-match-none-query)
 */
public struct MatchNone: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.matchNone

    public init() {}
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {}
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {}
}
