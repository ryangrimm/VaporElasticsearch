
import Foundation

/**
 A token filter of type length that removes words that are too long or too short for the stream.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-length-tokenfilter.html)
 */
public struct LengthFilter: TokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.length
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    public let name: String
    public let min: Int
    public let max: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case min
        case max
    }
    
    public init(name: String, min: Int, max: Int) {
        self.name = name
        self.min = min
        self.max = max
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.min = try container.decode(Int.self, forKey: .min)
        self.max = try container.decode(Int.self, forKey: .max)
    }
}
