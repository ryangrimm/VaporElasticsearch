import Foundation

/**
 Matches documents that have fields matching a wildcard expression (not
 analyzed). Supported wildcards are *, which matches any character sequence
 (including the empty one), and ?, which matches any single character. Note
 that this query can be slow, as it needs to iterate over many terms. In order
 to prevent extremely slow wildcard queries, a wildcard term should not start
 with one of the wildcards * or ?.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-wildcard-query.html)
 */
public struct Wildcard: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.wildcard

    /// :nodoc:
    public var codingKey = "wildcard"

    let key: String
    let value: String
    let boost: Decimal?

    public init(key: String, value: String, boost: Decimal?) {
        self.key = key
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
        let inner = Wildcard.Inner(value: value, boost: boost)

        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Wildcard.Inner(from: innerDecoder)
        self.value = inner.value
        self.boost = inner.boost
    }
}
