
import Foundation

public struct ExtendedStatsAggregation: Aggregation {
    public static var typeKey = AggregationMap.extendedStats
    
    public var codingKey = "extended_stats"
    public var name: String

    let field: String?
    let sigma: Int?
    let script: AggregationScript?
    let missing: Int?
    
    enum CodingKeys: String, CodingKey {
        case field
        case sigma
        case script
        case missing
    }
    
    public init(
        name: String,
        field: String? = nil,
        sigma: Int? = nil,
        script: AggregationScript? = nil,
        missing: Int? = nil
        ) {
        self.name = name
        self.field = field
        self.sigma = sigma
        self.script = script
        self.missing = missing
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encodeIfPresent(field, forKey: .field)
        try valuesContainer.encodeIfPresent(sigma, forKey: .sigma)
        try valuesContainer.encodeIfPresent(script, forKey: .script)
        try valuesContainer.encodeIfPresent(missing, forKey: .missing)
    }
}
