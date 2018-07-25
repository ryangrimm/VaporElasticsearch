
import Foundation

/**
 A token filter of type nGram.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-ngram-tokenfilter.html)
 */
public struct NGramFilter: TokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.nGram
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    public let name: String
    public let minGram: Int
    public let maxGram: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case minGram = "min_gram"
        case maxGram = "max_gram"
    }
    
    public init(name: String, minGram: Int, maxGram: Int) {
        self.name = name
        self.minGram = minGram
        self.maxGram = maxGram
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.minGram = try container.decode(Int.self, forKey: .minGram)
        self.maxGram = try container.decode(Int.self, forKey: .maxGram)
    }
}
