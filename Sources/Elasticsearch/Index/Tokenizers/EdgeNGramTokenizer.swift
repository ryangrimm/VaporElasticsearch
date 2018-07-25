
import Foundation

/**
 The edge_ngram tokenizer first breaks text down into words whenever it encounters one of a list of specified characters, then it emits N-grams of each word where the start of the N-gram is anchored to the beginning of the word.
 
 Edge N-Grams are useful for search-as-you-type queries.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-edgengram-tokenizer.html)
 */
public struct EdgeNGramTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.edgengram
    
    public enum CharacterClass: String, Codable {
        case letter
        case digit
        case whitespace
        case punctuation
        case symbol
    }
    
    /// Holds the string that Elasticsearch uses to identify the tokenizer type
    public let type = typeKey.rawValue
    public let name: String
    public let minGram: Int?
    public let maxGram: Int?
    public let tokenChars: [CharacterClass]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case minGram = "min_gram"
        case maxGram = "max_gram"
        case tokenChars = "token_chars"
    }
    
    public init(name: String, minGram: Int, maxGram: Int, tokenChars: [CharacterClass]? = nil) {
        self.name = name
        self.minGram = minGram
        self.maxGram = maxGram
        self.tokenChars = tokenChars
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.minGram = try container.decodeIfPresent(Int.self, forKey: .minGram)
        self.maxGram = try container.decodeIfPresent(Int.self, forKey: .maxGram)
        self.tokenChars = try container.decodeIfPresent([CharacterClass].self, forKey: .tokenChars)
    }
}
