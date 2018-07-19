
import Foundation

public struct SimplePatternSplitTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.simplePatternSplit
    
    let tokenizer = typeKey.rawValue
    
    public var pattern: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case pattern
    }
}
