
import Foundation

/**
The lowercase tokenizer, like the letter tokenizer breaks text into terms whenever it encounters a character which is not a letter, but it also lowercases all terms. It is functionally equivalent to the letter tokenizer combined with the lowercase token filter, but is more efficient as it performs both steps in a single pass.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lowercase-tokenizer.html)
 */
public struct LowercaseTokenizer: Tokenizer, BultinTokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.lowercase
    
    /// Holds the string that Elasticsearch uses to identify the tokenizer type
    public let type = typeKey.rawValue
    public let name: String
    
    public init() {
        self.name = type
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(type)
    }
}
