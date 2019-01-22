public protocol AggregationResponse: Decodable {
    var name: String { get set }
}

public struct AggregationBucket: Decodable {
    public let key: String
    public let docCount: Int
    public let docCountErrorUpperBound: Int?
        
    enum CodingKeys: String, CodingKey {
        case key
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
