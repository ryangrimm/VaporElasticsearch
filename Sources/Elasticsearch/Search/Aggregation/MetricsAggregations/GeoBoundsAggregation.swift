
import Foundation

/**
 A metric aggregation that computes the bounding box containing all geo_point values for a field.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-geobounds-aggregation.html)
 */
public struct GeoBoundsAggregation: Aggregation {
    public var aggs: [Aggregation]?
  
    /// :nodoc:
    public static var typeKey = AggregationResponseMap.geoBounds
    
    /// :nodoc:
    public var name: String
    
    /// :nodoc:
    public let field: String?
    
    /// :nodoc:
    public let wrapLongitude: Bool?
    
    enum CodingKeys: String, CodingKey {
        case field
        case wrapLongitude = "wrap_longitude"
        case aggs
    }
    
    /// Creates a [geo_bounds](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-geobounds-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - field: The field to perform the aggregation over
    ///   - wrapLongitude: Specifies whether the bounding box should be allowed to overlap the international date line
    public init(name: String,
                field: String? = nil,
                wrapLongitude: Bool? = nil,
                aggs: [Aggregation]? = nil
      ) {
        self.name = name
        self.field = field
        self.wrapLongitude = wrapLongitude
        self.aggs = aggs
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: type(of: self).typeKey.rawValue)!)
        try valuesContainer.encodeIfPresent(field, forKey: .field)
        try valuesContainer.encodeIfPresent(wrapLongitude, forKey: .wrapLongitude)
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
