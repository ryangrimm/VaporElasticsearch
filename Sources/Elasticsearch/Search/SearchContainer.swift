import Foundation

public struct SearchContainer: Encodable {
    let query: Query?
    let aggs: [Aggregation]?
    
    enum CodingKeys: String, CodingKey {
        case query
        case aggs
    }

    public init(aggs: [Aggregation]) {
        self.query = nil
        self.aggs = aggs
    }
    
    public init(_ query: Query? = nil, aggs: [Aggregation]? = nil) {
        self.query = query
        self.aggs = aggs
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if query != nil {
            try container.encode(query, forKey: .query)
        }
        if aggs != nil && aggs!.count > 0 {
            var aggContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .aggs)
            for agg in aggs! {
                try aggContainer.encode(AnyAggregation(agg), forKey: DynamicKey(stringValue: agg.name)!)
            }
        }
    }
}
