
import Foundation

/**
The letter tokenizer breaks text into terms whenever it encounters a character which is not a letter. It does a reasonable job for most European languages, but does a terrible job for some Asian languages, where words are not separated by spaces.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-standard-tokenizer.html)
 */
public struct LetterTokenizer: Tokenizer, BultinTokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.letter
    
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
