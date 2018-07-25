
import Foundation

/**
 The simple pattern tokenizer uses a regular expression to capture matching text as terms. The set of regular expression features it supports is more limited than the pattern tokenizer, but the tokenization is generally faster.
 
 This tokenizer does not support splitting the input on a pattern match, unlike the pattern tokenizer. To split on pattern matches using the same restricted regular expression subset, see the simple_pattern_split tokenizer.
 
 This tokenizer uses Lucene regular expressions. For an explanation of the supported features and syntax, see Regular Expression Syntax.
 
 The default pattern is the empty string, which produces no terms. This tokenizer should always be configured with a non-default pattern.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-simplepattern-tokenizer.html)
 */
public struct SimplePatternTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.simplePattern
    
    public let type = typeKey.rawValue
    public let name: String
    public let pattern: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case pattern
    }
    
    public init(name: String, pattern: String) {
        self.name = name
        self.pattern = pattern
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
    }
}
