import Foundation

public struct AggregationGeoCentroidResponse: AggregationResponse {
    public var name: String
    public let location: BoundsPoint
    public let count: Int
    
    public struct BoundsPoint: Decodable {
        public let lat: Float
        public let lon: Float
    }
    
    enum CodingKeys: String, CodingKey {
        case location
        case count
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.location = try container.decode(BoundsPoint.self, forKey: .location)
        self.count = try container.decode(Int.self, forKey: .count)
    }
}
