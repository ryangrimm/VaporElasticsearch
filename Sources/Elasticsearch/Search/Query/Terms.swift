import Foundation

/**
 Filters documents that have fields that match any of the provided terms (not analyzed).

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-terms-query.html)
 */
public struct Terms: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.terms

    let field: String
    let values: [String]

    public init(field: String, values: [String]) {
        self.field = field
        self.values = values
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(values, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue
        self.values = try container.decode([String].self, forKey: key!)
    }
}
