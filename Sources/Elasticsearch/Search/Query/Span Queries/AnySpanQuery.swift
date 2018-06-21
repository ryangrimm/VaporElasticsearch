
public typealias SpanQueryElement = SpanQuery & QueryElement

internal struct AnySpanQuery : Codable {
    public var base: QueryElement
    
    init(_ base: SpanQueryElement) {
        self.base = base
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        let type = QueryElementMap(rawValue: key!.stringValue)!
        let innerDecoder = try container.superDecoder(forKey: key!)
        self.base = try type.metatype.init(from: innerDecoder)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

