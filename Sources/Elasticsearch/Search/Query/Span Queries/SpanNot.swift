import Foundation

public struct SpanNot: QueryElement, SpanQuery {
    /// :nodoc:
    public static var typeKey = QueryElementMap.spanNot
    
    let include: SpanQueryElement
    let exclude: SpanQueryElement

    let pre: Int?
    let post: Int?
    let dist: Int?

    enum CodingKeys: String, CodingKey {
        case include
        case exclude
        case pre
        case post
        case dist
    }
    
    public init(include: SpanQueryElement, exclude: SpanQueryElement, pre: Int? = nil, post: Int? = nil, dist: Int? = nil) {
        self.include = include
        self.exclude = exclude
        self.pre = pre
        self.post = post
        self.dist = dist
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var includeContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .include)
        try includeContainer.encode(AnySpanQuery(self.include), forKey: DynamicKey(stringValue: type(of: self.include).typeKey.rawValue)!)
        var excludeContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .exclude)
        try excludeContainer.encode(AnySpanQuery(self.exclude), forKey: DynamicKey(stringValue: type(of: self.exclude).typeKey.rawValue)!)

        try container.encodeIfPresent(pre, forKey: .pre)
        try container.encodeIfPresent(post, forKey: .post)
        try container.encodeIfPresent(dist, forKey: .dist)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.include = try container.decode(AnySpanQuery.self, forKey: .include).base as! SpanQueryElement
        self.exclude = try container.decode(AnySpanQuery.self, forKey: .exclude).base as! SpanQueryElement
        self.pre = try container.decodeIfPresent(Int.self, forKey: .pre)
        self.post = try container.decodeIfPresent(Int.self, forKey: .post)
        self.dist = try container.decodeIfPresent(Int.self, forKey: .dist)
    }
}
