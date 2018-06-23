import Foundation

extension JSONDecoder {
    internal static let elasticUserInfoKey = CodingUserInfoKey(rawValue: "com.elastic.swift")!
    
    internal func setUserInfo(fromAggregations aggregations: [Aggregation]) {
        var aggNameMap = [String: AggregationResponse.Type]()
        
        for agg in aggregations {
            let responseType = AggregationResponseMap(rawValue: type(of: agg).typeKey.rawValue)
            aggNameMap[agg.name] = responseType?.metatype
        }
        self.userInfo = [JSONDecoder.elasticUserInfoKey: aggNameMap]
    }
}

extension Decoder {
    internal func getAggregationResponseType(forAggregationName name: String) throws -> AggregationResponse? {
        let aggNameMap = self.userInfo[JSONDecoder.elasticUserInfoKey] as! [String: AggregationResponse.Type]
        
        if aggNameMap[name] != nil {
            let responseType = aggNameMap[name]!
            return try responseType.init(from: self)
        }
        
        return nil
    }
}
