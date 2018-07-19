
import Foundation

public struct UAXURLEmailTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.UAXURLEmail
    
    let tokenizer = typeKey.rawValue
    
    public var maxTokenLength: Int
    
    enum CodingKeys: String, CodingKey {
        case maxTokenLength = "max_token_length"
    }
}
