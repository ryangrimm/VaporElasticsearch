
import Foundation

public struct NGramTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.ngram
    
    public enum CharacterClass: String, Codable {
        case letter
        case digit
        case whitespace
        case punctuation
        case symbol
    }
    
    let type = typeKey.rawValue
    
    public let name: String

    public var minGram: Int? = nil
    public var maxGram: Int? = nil
    public var tokenChars: [CharacterClass]? = nil
    
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
