public protocol AggregationResponse: Decodable {
    var name: String { get set }
}

public struct AggregationBucket<T: Decodable>: Decodable {
    public typealias HitsContainer = SearchResponse<T>.HitsContainer
    public typealias AggregationHits = [String: HitsContainer]

    public let key: String
    public let docCount: Int
    public let docCountErrorUpperBound: Int?
    public var hitsMap: AggregationHits = [:]

    enum CodingKeys: String, CodingKey {
        case key
        case hitsMap
        case docCount = "doc_count"
        case docCountErrorUpperBound = "doc_count_error_upper_bound"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        docCount = try container.decode(Int.self, forKey: .docCount)
        docCountErrorUpperBound = try container.decodeIfPresent(Int.self,
                                                                forKey: .docCountErrorUpperBound)

        if let value = try? container.decode(Int.self, forKey: .key) {
            key = String(value)
        } else {
            key = try container.decode(String.self, forKey: .key)
        }

        let dynamicContainer = try decoder.container(keyedBy: DynamicKey.self)
        let hitsKey = DynamicKey(stringValue: "hits")!

        for key in dynamicContainer.allKeys {
            do {
                let nestedContainer = try dynamicContainer.nestedContainer(keyedBy: DynamicKey.self, forKey: key)
                if nestedContainer.contains(hitsKey) {
                     let hits = try nestedContainer.decode(HitsContainer.self, forKey: hitsKey)
                     hitsMap[key.stringValue] = hits
                }

            } catch {}
        }
    }
}

public struct AggregationIntBucket: Decodable {
    public let key: Int
    public let docCount: Int

    enum CodingKeys: String, CodingKey {
        case key
        case docCount = "doc_count"
    }
}

public struct AggregationDateBucket: Decodable {
    public let key: Int64
    public let date: Date
    public let docCount: Int

    enum CodingKeys: String, CodingKey {
        case key
        case docCount = "doc_count"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.docCount = try container.decode(Int.self, forKey: .docCount)
        self.key = try container.decode(Int64.self, forKey: .key)
        self.date = Date(timeIntervalSince1970: TimeInterval(self.key / 1000))
    }
}
