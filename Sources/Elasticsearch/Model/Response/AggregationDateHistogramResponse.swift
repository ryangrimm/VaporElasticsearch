import Foundation

public struct AggregationDateHistogramResponse: AggregationResponse {
    public var name: String
    public let buckets: [AggregationDateBucket]
    
    enum CodingKeys: String, CodingKey {
        case buckets
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.buckets = try container.decode([AggregationDateBucket].self, forKey: .buckets)
    }
}
