import Foundation

public struct MatchAll: QueryElement {
    public static var typeKey = QueryElementMap.matchAll

    public var codingKey = "match_all"

    public init() {}
    public func encode(to encoder: Encoder) throws {}
    
    public init(from decoder: Decoder) throws {
    }
}
