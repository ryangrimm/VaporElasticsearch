import Foundation

/**
 This is the topmost container for specifying a query.
 */
public struct SearchContainer: Encodable {
    let query: Query?
    let aggs: [Aggregation]?
    let from: Int
    let size: Int

    enum CodingKeys: String, CodingKey {
        case query
        case aggs
        case from
        case size
    }

    public init(aggs: [Aggregation]) {
        self.init(nil, aggs: aggs)
    }

    public init(_ query: Query? = nil, aggs: [Aggregation]? = nil, from: Int = 0, size: Int = 10) {
        self.query = query
        self.aggs = aggs
        self.from = from
        self.size = size
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(from, forKey: .from)
        try container.encode(size, forKey: .size)

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
