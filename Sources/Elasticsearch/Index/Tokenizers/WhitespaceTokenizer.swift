
import Foundation

public struct WhitespaceTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.whitespace
    
    let tokenizer = typeKey.rawValue
    
    public var maxTokenLength: Int?
    
    enum CodingKeys: String, CodingKey {
        case maxTokenLength = "max_token_length"
    }
    
    public init(maxTokenLength: Int? = nil) {
        self.maxTokenLength = maxTokenLength
    }
}
