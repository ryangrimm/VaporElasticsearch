
import Foundation

public struct GeoCentroidAggregation: Aggregation {
    public static var typeKey = AggregationResponseMap.geoCentroid
    
    public var codingKey = "geo_centroid"
    public var name: String

    let field: String?
    
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encode(field, forKey: .field)
    }
}
