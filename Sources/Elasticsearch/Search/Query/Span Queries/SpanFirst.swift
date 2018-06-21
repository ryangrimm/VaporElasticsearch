import Foundation

public struct SpanFirst: QueryElement, SpanQuery {
    /// :nodoc:
    public static var typeKey = QueryElementMap.spanFirst
    
    /// :nodoc:
    public var codingKey = "span_first"
    
    let match: SpanQueryElement
    let end: Int
    
    enum CodingKeys: String, CodingKey {
        case match
        case end
    }
    
    public init(match: SpanQueryElement, end: Int) {
        self.match = match
        self.end = end
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var matchContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .match)
        try matchContainer.encode(AnySpanQuery(self.match), forKey: DynamicKey(stringValue: self.match.codingKey)!)
        try container.encode(end, forKey: .end)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.match = try container.decode(AnySpanQuery.self, forKey: .match).base as! SpanQueryElement
        self.end = try container.decode(Int.self, forKey: .end)
    }
}
