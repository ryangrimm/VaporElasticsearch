
import Foundation

public struct MinAggregation: Aggregation {
    public static var typeKey = AggregationResponseMap.min
    
    public var codingKey = "min"
    public var name: String

    let field: String?
    let script: Script?
    let missing: Int?
    
    enum CodingKeys: String, CodingKey {
        case field
        case script
        case missing
    }
    
    public init(
        name: String,
        field: String? = nil,
        script: Script? = nil,
        missing: Int? = nil
        ) {
        self.name = name
        self.field = field
        self.script = script
        self.missing = missing
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encodeIfPresent(field, forKey: .field)
        try valuesContainer.encodeIfPresent(script, forKey: .script)
        try valuesContainer.encodeIfPresent(missing, forKey: .missing)
    }
}
