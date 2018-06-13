
import Foundation

public struct TopHitsAggregation: Aggregation {
    public static var typeKey = AggregationMap.topHits
    
    public var codingKey = "top_hits"
    public var name: String
    
    let from: Int?
    let size: Int?
    
    enum CodingKeys: String, CodingKey {
        case from
        case size
    }
    
    public init(
        name: String,
        from: Int? = nil,
        size: Int? = nil
        ) {
        self.name = name
        self.from = from
        self.size = size
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encodeIfPresent(from, forKey: .from)
        try valuesContainer.encodeIfPresent(size, forKey: .size)
    }
}
