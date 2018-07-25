
import Foundation

/**
 The simple pattern split tokenizer uses a regular expression to split the input into terms at pattern matches. The set of regular expression features it supports is more limited than the pattern tokenizer, but the tokenization is generally faster.
 
 This tokenizer does not produce terms from the matches themselves. To produce terms from matches using patterns in the same restricted regular expression subset, see the simple_pattern tokenizer.
 
 This tokenizer uses Lucene regular expressions. For an explanation of the supported features and syntax, see Regular Expression Syntax.
 
 The default pattern is the empty string, which produces one term containing the full input. This tokenizer should always be configured with a non-default pattern.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-simplepatternsplit-tokenizer.html)
 */
public struct SimplePatternSplitTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.simplePatternSplit
    
    /// Holds the string that Elasticsearch uses to identify the tokenizer type
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
