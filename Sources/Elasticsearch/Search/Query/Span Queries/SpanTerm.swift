import Foundation

public struct SpanTerm: SpanQuery, QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.spanTerm
    
    let field: String
    let term: String
    let boost: Decimal?

    public init(field: String, term: String, boost: Decimal? = nil) {
        self.field = field
        self.term = term
        self.boost = boost
    }
    
    private struct Inner: Codable {
        let term: String
        let boost: Decimal?
        
        enum CodingKeys: String, CodingKey {
            case term
            case boost
        }
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = SpanTerm.Inner(term: term, boost: boost)
        
        try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try SpanTerm.Inner(from: innerDecoder)
        self.term = inner.term
        self.boost = inner.boost
    }
}
