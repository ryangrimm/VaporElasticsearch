
import Foundation

/**
 The classic tokenizer is a grammar based tokenizer that is good for English language documents. This tokenizer has heuristics for special treatment of acronyms, company names, email addresses, and internet host names. However, these rules don’t always work, and the tokenizer doesn’t work well for most languages other than English:
 
 * It splits words at most punctuation characters, removing punctuation. However, a dot that’s not followed by whitespace is considered part of a token.
 * It splits words at hyphens, unless there’s a number in the token, in which case the whole token is interpreted as a product number and is not split.
 * It recognizes email addresses and internet hostnames as one token.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-classic-tokenizer.html)
 */
public struct ClassicTokenizer: Tokenizer, BultinTokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.classic
    
    /// Holds the string that Elasticsearch uses to identify the tokenizer type
    public let type = typeKey.rawValue
    public let name: String
    public let maxTokenLength: Int?
    
    let isCustom: Bool
    
    enum CodingKeys: String, CodingKey {
        case type
        case maxTokenLength = "max_token_length"
    }
    
    public init() {
        self.name = type
        self.maxTokenLength = nil
        self.isCustom = false
    }
    
    public init(name: String, maxTokenLength: Int) {
        self.name = name
        self.maxTokenLength = maxTokenLength
        self.isCustom = true
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        if self.isCustom {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encode(maxTokenLength, forKey: .maxTokenLength)
        }
        else {
            var container = encoder.singleValueContainer()
            try container.encode(type)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.maxTokenLength = try container.decodeIfPresent(Int.self, forKey: .maxTokenLength)
        self.isCustom = true
    }
}
