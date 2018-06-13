import Foundation

public struct MatchNone: QueryElement {
    public static var typeKey = QueryElementMap.matchNone

    public var codingKey = "match_none"

    public init() {}
    public func encode(to encoder: Encoder) throws {}
}
