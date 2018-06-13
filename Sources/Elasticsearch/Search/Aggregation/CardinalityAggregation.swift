
import Foundation

public struct CardinalityAggregation: Aggregation {
    public static var typeKey = AggregationMap.cardinality
    
    public var codingKey = "cardinality"
    public var name: String

    let field: String?
    let precisionThreshold: Int?
    let script: AggregationScript?
    let missing: String?
    
    enum CodingKeys: String, CodingKey {
        case field
        case precisionThreshold = "precision_threshold"
        case script
        case missing
    }
    
    public init(
        name: String,
        field: String? = nil,
        precisionThreshold: Int? = nil,
        script: AggregationScript? = nil,
        missing: String? = nil
        ) {
        self.name = name
        self.field = field
        self.precisionThreshold = precisionThreshold
        self.script = script
        self.missing = missing
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encodeIfPresent(field, forKey: .field)
        try valuesContainer.encodeIfPresent(precisionThreshold, forKey: .precisionThreshold)
        try valuesContainer.encodeIfPresent(script, forKey: .script)
        try valuesContainer.encodeIfPresent(missing, forKey: .missing)
    }
}
