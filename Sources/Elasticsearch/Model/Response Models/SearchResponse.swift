import Foundation

public struct SearchResponse<T: Decodable>: Decodable {
    public let took: Int
    public let timedOut: Bool
    public let shards: Shards
    public let hits: HitsContainer
    
    public struct Shards: Decodable {
        public let total: Int
        public let successful: Int
        public let skipped: Int
        public let failed: Int
    }
    
    public struct HitsContainer: Decodable {
        public let total: Int
        public let maxScore: Decimal?
        public let hits: [Hit]
        
        public struct Hit: Decodable {
            public let index: String
            public let type: String
            public let id: String
            public let score: Decimal
            public let source: T
            
            enum CodingKeys: String, CodingKey {
                case index = "_index"
                case type = "_type"
                case id = "_id"
                case score = "_score"
                case source = "_source"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case total
            case maxScore = "max_score"
            case hits
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case shards = "_shards"
        case hits
    }
}
