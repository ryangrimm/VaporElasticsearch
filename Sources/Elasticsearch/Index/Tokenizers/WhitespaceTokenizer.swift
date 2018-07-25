
import Foundation

/**
 The whitespace tokenizer breaks text into terms whenever it encounters a whitespace character.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-whitespace-tokenizer.html)
 */
public struct WhitespaceTokenizer: Tokenizer, BultinTokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.whitespace
    
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
