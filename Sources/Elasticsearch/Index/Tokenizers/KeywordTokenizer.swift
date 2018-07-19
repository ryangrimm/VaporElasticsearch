
import Foundation

public struct KeywordTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.keyword
    
    let tokenizer = typeKey.rawValue
    
    public var bufferSize: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case bufferSize = "buffer_size"
    }
}
