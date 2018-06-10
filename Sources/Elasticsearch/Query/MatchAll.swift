import Foundation

public struct MatchAll: QueryElement {
    public var codingKey = "match_all"

    public init() {}
    public func encode(to encoder: Encoder) throws {}
}
