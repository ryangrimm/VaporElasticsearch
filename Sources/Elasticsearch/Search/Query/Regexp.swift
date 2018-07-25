import Foundation

/**
 The regexp query allows you to use regular expression term queries. See
 Regular expression syntax for details of the supported regular expression
 language. The "term queries" in that first sentence means that Elasticsearch
 will apply the regexp to the terms produced by the tokenizer for that field,
 and not to the original text of the field.

 Note: The performance of a regexp query heavily depends on the regular
 expression chosen. Matching everything like .* is very slow as well as using
 lookaround regular expressions. If possible, you should try to use a long
 prefix before your regular expression starts. Wildcard matchers like .*?+ will
 mostly lower performance.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-regexp-query.html)
 */
public struct Regexp: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.regexp

    public let field: String
    public let value: String
    public let boost: Decimal?

    public init(field: String, value: String, boost: Decimal?) {
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
        let inner = Regexp.Inner(value: value, boost: boost)

        try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Regexp.Inner(from: innerDecoder)
        self.value = inner.value
        self.boost = inner.boost
    }
}
