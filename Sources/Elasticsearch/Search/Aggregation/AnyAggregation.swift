
import Foundation

/// :nodoc:
public enum AggregationResponseMap : String, Encodable {
    
    case avg
    case cardinality
    case extendedStats = "extended_stats"
    case geoBounds = "geo_bounds"
    case geoCentroid = "geo_centroid"
    case max
    case min
    case stats
    case sum
    case topHits = "top_hits"
    case valueCount = "value_count"
    case terms
    
    var metatype: AggregationResponse.Type? {
        switch self {
        case .avg:
            return AggregationSingleValueResponse.self
        case .cardinality:
            return AggregationSingleValueResponse.self
        case .extendedStats:
            return AggregationExtendedStatsResponse.self
        case .geoBounds:
            return AggregationGeoBoundsResponse.self
        case .geoCentroid:
            return AggregationGeoCentroidResponse.self
        case .max:
            return AggregationSingleValueResponse.self
        case .min:
            return AggregationSingleValueResponse.self
        case .stats:
            return AggregationStatsResponse.self
        case .sum:
            return AggregationSingleValueResponse.self
        case .topHits:
            return nil
        case .valueCount:
            return AggregationSingleValueResponse.self
        case .terms:
            return AggregationTermsResponse.self
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
