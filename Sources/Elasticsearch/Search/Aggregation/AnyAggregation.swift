
import Foundation

public enum AggregationResponseMap : String, Encodable {
    
    case avg
    case cardinality
    case extendedStats
    case geoBounds
    case geoCentroid
    case max
    case min
    case terms
    case stats
    case sum
    case topHits
    case valueCount
    
    var metatype: AggregationResponse.Type? {
        switch self {
        case .avg:
            return AggregationSingleValueResponse.self
        case .cardinality:
            return AggregationSingleValueResponse.self
        case .extendedStats:
            return nil
        case .geoBounds:
            return nil
        case .geoCentroid:
            return nil
        case .max:
            return AggregationSingleValueResponse.self
        case .min:
            return AggregationSingleValueResponse.self
        case .stats:
            return nil
        case .sum:
            return AggregationSingleValueResponse.self
        case .topHits:
            return nil
        case .valueCount:
            return AggregationSingleValueResponse.self
        default:
            return nil
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
