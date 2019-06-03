import Foundation

extension JSONDecoder {
    internal static let elasticAggs = CodingUserInfoKey(rawValue: "com.elastic.swift.aggs")!
    internal static let elasticAnalysis = CodingUserInfoKey(rawValue: "com.elastic.swift.analysis")!

    internal func userInfo(fromAggregations aggregations: [Aggregation]) {
        var aggNameMap = [String: Aggregation]()

        for agg in aggregations {
            aggNameMap[agg.name] = agg
        }
        self.userInfo = [JSONDecoder.elasticAggs: aggNameMap]
    }

    internal func userInfo(analysis: Analysis) {
        self.userInfo = [JSONDecoder.elasticAnalysis: analysis]
    }
}

extension Decoder {
    internal func aggregationResponseType<T: Decodable>(forAggregationName name: String, docType: T.Type) throws -> AggregationResponse? {
        let aggDefinitionMap = self.userInfo[JSONDecoder.elasticAggs] as! [String: Aggregation]

        if let defintion = aggDefinitionMap[name] {
            if let responseType = AggregationResponseMap(rawValue: type(of: defintion).typeKey.rawValue),
                let metatype = responseType.metatype(docType: docType) {
                    return try metatype.init(from: self)
            }
        }

        return nil
    }

    internal func aggregationDefinition(forAggregationName name: String) throws -> Aggregation? {
        let aggDefinitionMap = self.userInfo[JSONDecoder.elasticAggs] as! [String: Aggregation]
        return aggDefinitionMap[name]
    }

    internal func analysis() -> Analysis? {
        return self.userInfo[JSONDecoder.elasticAnalysis] as? Analysis
    }
}
