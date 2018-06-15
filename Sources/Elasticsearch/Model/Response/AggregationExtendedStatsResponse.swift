import Foundation

public struct AggregationExtendedStatsResponse: AggregationResponse {
    public var name: String
    public let count: Int
    public let min: Float
    public let max: Float
    public let avg: Float
    public let sum: Float
    public let sumOfSquares: Float
    public let variance: Float
    public let stdDeviation: Float
    public let stdDeviationBounds: StandardDeviationBounds
    
    public struct StandardDeviationBounds: Decodable {
        public let upper: Float
        public let lower: Float
    }

    enum CodingKeys: String, CodingKey {
        case count
        case min
        case max
        case avg
        case sum
        case sumOfSquares = "sum_of_squares"
        case variance
        case stdDeviation = "std_deviation"
        case stdDeviationBounds = "std_deviation_bounds"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.count = try container.decode(Int.self, forKey: .count)
        self.min = try container.decode(Float.self, forKey: .min)
        self.max = try container.decode(Float.self, forKey: .max)
        self.avg = try container.decode(Float.self, forKey: .avg)
        self.sum = try container.decode(Float.self, forKey: .sum)
        self.sumOfSquares = try container.decode(Float.self, forKey: .sumOfSquares)
        self.variance = try container.decode(Float.self, forKey: .variance)
        self.stdDeviation = try container.decode(Float.self, forKey: .stdDeviation)
        self.stdDeviationBounds = try container.decode(StandardDeviationBounds.self, forKey: .stdDeviationBounds)
    }
}
