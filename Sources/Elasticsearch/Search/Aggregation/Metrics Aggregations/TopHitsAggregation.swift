
import Foundation
/**
 A top_hits metric aggregator keeps track of the most relevant document being
 aggregated. This aggregator is intended to be used as a sub aggregator, so that
 the top matching documents can be aggregated per bucket.

 The top_hits aggregator can effectively be used to group result sets by certain
 fields via a bucket aggregator. One or more bucket aggregators determines by
 which properties a result set get sliced into.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-top-hits-aggregation.html)
 */
public struct TopHitsAggregation: Aggregation {
    /// :nodoc:
    public static var typeKey = AggregationResponseMap.topHits
    
    /// :nodoc:
    public var codingKey = "top_hits"
    
    /// :nodoc:
    public var name: String
    
    /// :nodoc:
    public let from: Int?
    
    /// :nodoc:
    public let size: Int?
    
    enum CodingKeys: String, CodingKey {
        case from
        case size
    }
    
    /// Creates a [top_hits](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-top-hits-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - from: The offset from the first result you want to fetch
    ///   - size: The maximum number of top matching hits to return per bucket
    public init(
        name: String,
        from: Int? = nil,
        size: Int? = nil
        ) {
        self.name = name
        self.from = from
        self.size = size
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encodeIfPresent(from, forKey: .from)
        try valuesContainer.encodeIfPresent(size, forKey: .size)
    }
}
