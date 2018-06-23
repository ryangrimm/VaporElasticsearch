import Foundation

public struct SpanWithin: QueryElement, SpanQuery {
    /// :nodoc:
    public static var typeKey = QueryElementMap.spanWithin
    
    let little: SpanQueryElement
    let big: SpanQueryElement
    
    enum CodingKeys: String, CodingKey {
        case little
        case big
    }
    
    public init(little: SpanQueryElement, big: SpanQueryElement) {
        self.little = little
        self.big = big
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var littleContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .little)
        try littleContainer.encode(AnySpanQuery(self.little), forKey: DynamicKey(stringValue: type(of: self.little).typeKey.rawValue)!)
        var bigContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .big)
        try bigContainer.encode(AnySpanQuery(self.big), forKey: DynamicKey(stringValue: type(of: self.big).typeKey.rawValue)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.little = try container.decode(AnySpanQuery.self, forKey: .little).base as! SpanQueryElement
        self.big = try container.decode(AnySpanQuery.self, forKey: .big).base as! SpanQueryElement
    }
}
