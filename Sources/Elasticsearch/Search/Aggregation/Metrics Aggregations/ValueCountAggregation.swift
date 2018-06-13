
import Foundation

public struct ValueCountAggregation: Aggregation {
    public static var typeKey = AggregationMap.valueCount
    
    public var codingKey = "value_count"
    public var name: String
    
    let field: String?
    let script: AggregationScript?
    
    enum CodingKeys: String, CodingKey {
        case field
        case script
    }
    
    public init(
        name: String,
        field: String? = nil,
        script: AggregationScript? = nil,
        missing: Int? = nil
        ) {
        self.name = name
        self.field = field
        self.script = script
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encodeIfPresent(field, forKey: .field)
        try valuesContainer.encodeIfPresent(script, forKey: .script)
    }
}
