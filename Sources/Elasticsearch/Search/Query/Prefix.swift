import Foundation

/**
 Matches documents that have fields containing terms with a specified prefix
 (not analyzed). The prefix query maps to Lucene PrefixQuery.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-prefix-query.html)
 */
public struct Prefix: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.prefix

    /// :nodoc:
    public var codingKey = "prefix"

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
        let inner = Prefix.Inner(value: value, boost: boost)

        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Prefix.Inner(from: innerDecoder)
        self.value = inner.value
        self.boost = inner.boost
    }
}
