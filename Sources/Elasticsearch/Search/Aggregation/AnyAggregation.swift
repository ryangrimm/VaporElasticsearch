
import Foundation

public enum AggregationMap : String, Encodable {
    
    case avg
    case cardinality
    case extendedStats
    case geoBounds
    case geoCentroid
    case max
    case min
    
    var metatype: Aggregation.Type {
        switch self {
        case .avg:
            return AvgAggregation.self
        case .cardinality:
            return CardinalityAggregation.self
        case .extendedStats:
            return ExtendedStatsAggregation.self
        case .geoBounds:
            return GeoBoundsAggregation.self
        case .geoCentroid:
            return GeoCentroidAggregation.self
        case .max:
            return MaxAggregation.self
        case .min:
            return MinAggregation.self
        }
    }
}

internal struct AnyAggregation : Encodable {
    public var base: Aggregation
    
    init(_ base: Aggregation) {
        self.base = base
    }
    
    private enum CodingKeys : CodingKey {
        case type
        case base
    }
    
    /*
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(AggregationMap.self, forKey: .type)
        self.base = try type.metatype.init(from: decoder)
    }
    */
    
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}
