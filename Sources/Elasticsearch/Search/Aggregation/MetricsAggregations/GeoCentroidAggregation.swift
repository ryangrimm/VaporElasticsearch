
import Foundation

/**
 A metric aggregation that computes the weighted centroid from all coordinate
 values for a Geo-point datatype field.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-geocentroid-aggregation.html)
 */
public struct GeoCentroidAggregation: Aggregation {
    public var aggs: [Aggregation]?
  
    /// :nodoc:
    public static var typeKey = AggregationResponseMap.geoCentroid
    
    /// :nodoc:
    public var name: String
    
    /// :nodoc:
    public let field: String?
    
    enum CodingKeys: String, CodingKey {
        case field
        case aggs
    }
    
    /// Creates a [geo_point](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-geocentroid-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - field: The field to perform the aggregation over
  public init(name: String, field: String, aggs: [Aggregation]? = nil) {
        self.name = name
        self.field = field
        self.aggs = aggs
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: type(of: self).typeKey.rawValue)!)
        try valuesContainer.encode(field, forKey: .field)
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
