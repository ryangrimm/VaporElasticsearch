
import Foundation

internal struct AnyAggregationResponse : Decodable {
    public var base: AggregationResponse?
    
    init(_ base: AggregationResponse) {
        self.base = base
    }
    
    private enum CodingKeys : CodingKey {
        case base
    }
    
    public init(from decoder: Decoder) throws {        
        let aggName = (decoder.codingPath.last?.stringValue)!
        self.base = try decoder.getAggregationResponseType(forAggregationName: aggName)
    }
}
