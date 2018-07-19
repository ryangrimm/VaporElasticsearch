
import Foundation

public struct ThaiTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.thai
    
    let tokenizer = typeKey.rawValue
}
