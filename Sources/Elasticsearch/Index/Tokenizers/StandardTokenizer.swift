
import Foundation

public struct StandardTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.standard
    
    let tokenizer = typeKey.rawValue
    
    public var maxTokenLength: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case maxTokenLength = "max_token_length"
    }
    
    public init(maxTokenLength: Int? = nil) {
        self.maxTokenLength = maxTokenLength
    }
}
