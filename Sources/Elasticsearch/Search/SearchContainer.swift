import Foundation

/**
 This is the topmost container for specifying a query.
 */
public struct SearchContainer: Encodable {
    public let query: Query?
    public let aggs: [Aggregation]?
    public let from: Int
    public let size: Int
    public let terminateAfter: Int?

    enum CodingKeys: String, CodingKey {
        case query
        case aggs
        case from
        case size
        case terminateAfter = "terminate_after"
    }

    public init(aggs: [Aggregation]) {
        self.init(nil, aggs: aggs)
    }

    public init(_ query: Query, aggs: [Aggregation]? = nil, from: Int = 0, size: Int = 10, terminateAfter: Int? = nil) {
        self.init(query, aggs: aggs, from: from, size: size)
    }
        
    private init(_ query: Query? = nil, aggs: [Aggregation]? = nil, from: Int = 0, size: Int = 10, terminateAfter: Int? = nil) {
        self.query = query
        self.aggs = aggs
        self.from = from
        self.size = query == nil ? 0: size
        self.terminateAfter = terminateAfter
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
