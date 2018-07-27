import Foundation

public struct AggregationHistogramResponse: AggregationResponse {
    public var name: String
    public let buckets: [AggregationIntBucket]
    
    enum CodingKeys: String, CodingKey {
        case buckets
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.buckets = try container.decode([AggregationIntBucket].self, forKey: .buckets)
    }
}
