import Foundation

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
