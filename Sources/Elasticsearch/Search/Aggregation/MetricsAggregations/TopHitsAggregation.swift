
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
    public var aggs: [Aggregation]?
  
    /// :nodoc:
    public static var typeKey = AggregationResponseMap.topHits
    
    /// :nodoc:
    public var name: String
    
    /// :nodoc:
    public let from: Int?
    
    /// :nodoc:
    public let size: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case from
        case size
        case aggs
    }
    
    /// Creates a [top_hits](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-top-hits-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - from: The offset from the first result you want to fetch
    ///   - size: The maximum number of top matching hits to return per bucket
  public init(name: String, from: Int? = nil, size: Int? = nil, aggs: [Aggregation]? = nil) {
        self.name = name
        self.from = from
        self.size = size
        self.aggs = aggs
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: type(of: self).typeKey.rawValue)!)
        try valuesContainer.encodeIfPresent(from, forKey: .from)
        try valuesContainer.encodeIfPresent(size, forKey: .size)
        if aggs != nil {
          if aggs != nil {
          if aggs != nil && aggs!.count > 0 {
          var aggContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: "aggs")!)
          for agg in aggs! {
            try aggContainer.encode(AnyAggregation(agg), forKey: DynamicKey(stringValue: agg.name)!)
          }
        }
      }
        }
    }
}
