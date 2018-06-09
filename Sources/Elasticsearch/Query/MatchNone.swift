import Foundation

public struct MatchNone: QueryElement {
    public typealias QueryType = MatchNone
    public var codingKey = "match_none"

    public init() {}
    public func encode(to encoder: Encoder) throws {}
}
