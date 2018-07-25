
import Foundation

/**
 The pattern tokenizer uses a regular expression to either split text into terms whenever it matches a word separator, or to capture matching text as terms.
 
 The default pattern is \W+, which splits text whenever it encounters non-word characters.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-pattern-tokenizer.html)
 */
public struct PatternTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.pattern
    
    /// Holds the string that Elasticsearch uses to identify the tokenizer type
    public let type = typeKey.rawValue
    public let name: String
    public let pattern: String?
    public let flags: String?
    public let group: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case pattern
        case flags
        case group
    }
    
    public init(name: String, pattern: String, flags: String? = nil, group: Int? = nil) {
        self.name = name
        self.pattern = pattern
        self.flags = flags
        self.group = group
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
        self.flags = try container.decodeIfPresent(String.self, forKey: .flags)
        self.group = try container.decodeIfPresent(Int.self, forKey: .group)
    }
}
