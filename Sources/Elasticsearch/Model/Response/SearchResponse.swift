import Foundation

public typealias Aggregations = [String: AggregationResponse]

public struct SearchResponse<T: Decodable>: Decodable {
    public let took: Int
    public let timedOut: Bool
    public let shards: Shards
    public let hits: HitsContainer?
    public let aggregations: Aggregations?
    public let terminatedEarly: Bool?
    
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
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.index = try container.decode(String.self, forKey: .index)
                self.type = try container.decode(String.self, forKey: .type)
                self.id = try container.decode(String.self, forKey: .id)
                self.score = try container.decode(Decimal.self, forKey: .score)
                var source = try container.decode(T.self, forKey: .source)
                if var settableIDSource = source as? SettableID {
                    settableIDSource.setID(self.id)
                    source = settableIDSource as! T
                }
                
                self.source = source
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
        case aggregations
        case terminatedEarly = "terminated_early"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.took = try container.decode(Int.self, forKey: .took)
        self.timedOut = try container.decode(Bool.self, forKey: .timedOut)
        self.shards = try container.decode(Shards.self, forKey: .shards)
        self.hits = try container.decode(HitsContainer.self, forKey: .hits)
        self.terminatedEarly = try container.decode(Bool.self, forKey: .terminatedEarly)
        
        if container.contains(.aggregations) {
            let aggsContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .aggregations)
            
            var aggregations = Aggregations()
            for key in aggsContainer.allKeys {
                let aggResponse = try aggsContainer.decode(AnyAggregationResponse.self, forKey: key).base
                aggregations[key.stringValue] = aggResponse
            }
            if aggregations.count > 0 {
                self.aggregations = aggregations
            }
            else {
                self.aggregations = nil
            }
        }
        else {
            self.aggregations = nil
        }
        
    }
}
