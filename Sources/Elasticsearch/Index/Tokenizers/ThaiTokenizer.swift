
import Foundation

/**
 The thai tokenizer segments Thai text into words, using the Thai segmentation algorithm included with Java. Text in other languages in general will be treated the same as the standard tokenizer.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-thai-tokenizer.html)
 */
public struct ThaiTokenizer: Tokenizer, BultinTokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.thai
    
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
