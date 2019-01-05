import Foundation

public struct SuggestResponse: Decodable {
    public let took: Int
    public let timedOut: Bool
    public let shards: Shards
    public let hits: HitsContainer?
    public let suggest: [String: [SuggestResult]]

    public var suggestions: [String] {
        return suggest.values
            .flatMap { $0 }
            .flatMap { $0.options }
            .compactMap { $0.text }
    }

    public struct Shards: Decodable {
        public let total: Int
        public let successful: Int
        public let skipped: Int
        public let failed: Int
    }

    public struct HitsContainer: Decodable {
        public let total: Int
        public let maxScore: Decimal?
    }

    public struct SuggestResult: Decodable {
        public let text: String
        public let offset: Int
        public let length: Int
        public let options: [SuggestOption]
    }

    public struct SuggestOption: Decodable {
        public let id: String
        public let text: String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case text
        }
    }

    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case shards = "_shards"
        case hits
        case suggest
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.took = try container.decode(Int.self, forKey: .took)
        self.timedOut = try container.decode(Bool.self, forKey: .timedOut)
        self.shards = try container.decode(Shards.self, forKey: .shards)
        self.hits = try container.decode(HitsContainer.self, forKey: .hits)
        self.suggest = try container.decode([String: [SuggestResult]].self, forKey: .suggest)
    }
}
