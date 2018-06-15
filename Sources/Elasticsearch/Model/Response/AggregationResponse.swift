public protocol AggregationResponse: Decodable {
    var name: String { get set }
}

public struct AggregationBucket: Decodable {
    public let key: String
    public let docCount: Int
    public let docCountErrorUpperBound: Int?
        
    enum CodingKeys: String, CodingKey {
        case key
        case docCount = "doc_count"
        case docCountErrorUpperBound = "doc_count_error_upper_bound"
    }
}
