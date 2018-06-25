import Foundation

/**
 The `Term` query finds documents that contain the exact term specified in the inverted index.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-term-query.html)
 */
public struct Term: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.term

    let field: String
    let value: String
    let boost: Decimal?

    public init(field: String, value: String, boost: Decimal? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
    }

    private struct Inner: Codable {
        let value: String
        let boost: Decimal?
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Term.Inner(value: value, boost: boost)

        try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Term.Inner(from: innerDecoder)
        self.value = inner.value
        self.boost = inner.boost
    }
}
