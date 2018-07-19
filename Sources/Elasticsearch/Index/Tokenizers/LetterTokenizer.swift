
import Foundation

public struct LetterTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.letter
    
    let tokenizer = typeKey.rawValue
}
