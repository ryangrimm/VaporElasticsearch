import Foundation

public struct AggregationGeoBoundsResponse: AggregationResponse {
    public var name: String
    public let bounds: BoundsContainer
    
    public struct BoundsContainer: Decodable {
        public let topLeft: BoundsPoint
        public let bottomRight: BoundsPoint
    }
    
    public struct BoundsPoint: Decodable {
        public let lat: Float
        public let lon: Float
    }

    enum CodingKeys: String, CodingKey {
        case bounds
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.bounds = try container.decode(BoundsContainer.self, forKey: .bounds)
    }
}
