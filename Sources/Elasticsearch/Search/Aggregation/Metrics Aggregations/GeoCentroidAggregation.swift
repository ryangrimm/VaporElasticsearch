
import Foundation

/**
 A metric aggregation that computes the weighted centroid from all coordinate
 values for a Geo-point datatype field.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-geocentroid-aggregation.html)
 */
public struct GeoCentroidAggregation: Aggregation {
    /// :nodoc:
    public static var typeKey = AggregationResponseMap.geoCentroid
    
    /// :nodoc:
    public var name: String
    
    /// :nodoc:
    public let field: String?
    
    enum CodingKeys: String, CodingKey {
        case field
    }
    
    /// Creates a [geo_point](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-geocentroid-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - field: The field to perform the aggregation over
    public init(
        name: String,
        field: String
        ) {
        self.name = name
        self.field = field
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: type(of: self).typeKey.rawValue)!)
        try valuesContainer.encode(field, forKey: .field)
    }
}
