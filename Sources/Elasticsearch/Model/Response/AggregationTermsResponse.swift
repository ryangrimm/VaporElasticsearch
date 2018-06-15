import Foundation

public struct AggregationTermsResponse: AggregationResponse {
    public var name: String
    public let docCountErrorUpperBound: Int
    public let sumOtherDocCount: Int
    public let buckets: [AggregationBucket]
    
    enum CodingKeys: String, CodingKey {
        case docCountErrorUpperBound = "doc_count_error_upper_bound"
        case sumOtherDocCount = "sum_other_doc_count"
        case buckets
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.docCountErrorUpperBound = try container.decode(Int.self, forKey: .docCountErrorUpperBound)
        self.sumOtherDocCount = try container.decode(Int.self, forKey: .sumOtherDocCount)
        self.buckets = try container.decode([AggregationBucket].self, forKey: .buckets)
    }
}
