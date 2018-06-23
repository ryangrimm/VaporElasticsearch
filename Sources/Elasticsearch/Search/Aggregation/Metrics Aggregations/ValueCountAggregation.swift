
import Foundation

/**
 A single-value metrics aggregation that counts the number of values that are
 extracted from the aggregated documents. These values can be extracted either
 from specific fields in the documents, or be generated by a provided script.
 Typically, this aggregator will be used in conjunction with other single-value
 aggregations. For example, when computing the avg one might be interested in
 the number of values the average is computed over.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-valuecount-aggregation.html)
 */
public struct ValueCountAggregation: Aggregation {
    /// :nodoc:
    public static var typeKey = AggregationResponseMap.valueCount
    
    /// :nodoc:
    public var name: String
    
    /// :nodoc:
    public let field: String?
    
    /// :nodoc:
    public let script: Script?
    
    enum CodingKeys: String, CodingKey {
        case field
        case script
    }
    
    /// Creates a [value_count](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-valuecount-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - field: The field to perform the aggregation over
    ///   - script: A script used to calculate the values
    ///   - missing: Defines how documents that are missing a value should be treated
    public init(
        name: String,
        field: String? = nil,
        script: Script? = nil,
        missing: Int? = nil
        ) {
        self.name = name
        self.field = field
        self.script = script
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: type(of: self).typeKey.rawValue)!)
        try valuesContainer.encodeIfPresent(field, forKey: .field)
        try valuesContainer.encodeIfPresent(script, forKey: .script)
    }
}
