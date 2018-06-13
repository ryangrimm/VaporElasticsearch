
import Foundation

public enum AggregationMap : String, Encodable {
    
    case avg
    case cardinality
    case extendedStats
    case geoBounds
    case geoCentroid
    case max
    case min
    case terms
    
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
        case .terms:
            return TermsAggregation.self
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
    
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}
