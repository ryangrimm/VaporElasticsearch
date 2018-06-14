
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
        let aggNameMap = decoder.userInfo[JSONDecoder.elasticUserInfoKey] as! [String: AggregationResponse.Type]
        
        let aggName = (decoder.codingPath.last?.stringValue)!
        if aggNameMap[aggName] != nil {
            let responseType = aggNameMap[aggName]!
            self.base = try responseType.init(from: decoder)
        }
        else {
            self.base = nil
        }
    }
}
