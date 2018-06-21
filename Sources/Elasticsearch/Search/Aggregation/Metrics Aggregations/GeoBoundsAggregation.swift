
import Foundation

public struct GeoBoundsAggregation: Aggregation {
    public static var typeKey = AggregationResponseMap.geoBounds
    
    public var codingKey = "geo_bounds"
    public var name: String

    let field: String?
    let wrapLongitude: Bool?
    
    enum CodingKeys: String, CodingKey {
        case field
        case wrapLongitude = "wrap_longitude"
    }
    
    /// Creates a [geo_bounds](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-geobounds-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - field: The field to perform the aggregation over
    ///   - wrapLongitude: Specifies whether the bounding box should be allowed to overlap the international date line
    public init(
        name: String,
        field: String? = nil,
        wrapLongitude: Bool? = nil
        ) {
        self.name = name
        self.field = field
        self.wrapLongitude = wrapLongitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encodeIfPresent(field, forKey: .field)
        try valuesContainer.encodeIfPresent(wrapLongitude, forKey: .wrapLongitude)
    }
}
