import Foundation

public struct AggregationStatsResponse: AggregationResponse {
    public var name: String
    public let count: Int
    public let min: Float
    public let max: Float
    public let avg: Float
    public let sum: Float
    
    enum CodingKeys: String, CodingKey {
        case count
        case min
        case max
        case avg
        case sum
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.count = try container.decode(Int.self, forKey: .count)
        self.min = try container.decode(Float.self, forKey: .min)
        self.max = try container.decode(Float.self, forKey: .max)
        self.avg = try container.decode(Float.self, forKey: .avg)
        self.sum = try container.decode(Float.self, forKey: .sum)
    }
}
