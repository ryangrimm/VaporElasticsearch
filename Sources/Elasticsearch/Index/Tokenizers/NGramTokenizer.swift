
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
    
    let tokenizer = typeKey.rawValue
    
    public var minGram: Int? = nil
    public var maxGram: Int? = nil
    public var tokenChars: [CharacterClass]? = nil
    
    enum CodingKeys: String, CodingKey {
        case minGram = "min_gram"
        case maxGram = "max_gram"
        case tokenChars = "token_chars"
    }
}
