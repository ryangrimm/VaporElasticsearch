import Foundation

public struct AggregationSingleValueResponse: AggregationResponse {
    public var name: String
    public let value: Float
    
    enum CodingKeys: String, CodingKey {
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.value = try container.decode(Float.self, forKey: .value)
    }
}
