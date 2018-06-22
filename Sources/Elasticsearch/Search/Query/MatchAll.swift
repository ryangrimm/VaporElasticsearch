import Foundation

/**
 The most simple query, which matches all documents, giving them all a score of 1.0

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-all-query.html)
 */
public struct MatchAll: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.matchAll

    /// :nodoc:
    public var codingKey = "match_all"

    public init() {}
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {}
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {}
}
