import Foundation

public struct MatchNone: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.matchNone

    /// :nodoc:
    public var codingKey = "match_none"

    public init() {}
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {}
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {}
}
