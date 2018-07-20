
import Foundation

public struct LowercaseTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.lowercase
    
    let tokenizer = typeKey.rawValue
    
    public init() {}
}
