
import Foundation

public struct ClassicTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.classic
    
    let tokenizer = typeKey.rawValue
    
    public var maxTokenLength: Int?
    
    enum CodingKeys: String, CodingKey {
        case maxTokenLength = "max_token_length"
    }
    
    public init(maxTokenLength: Int? = nil) {
        self.maxTokenLength = maxTokenLength
    }
}
