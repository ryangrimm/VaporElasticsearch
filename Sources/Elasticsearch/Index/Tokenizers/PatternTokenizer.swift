
import Foundation

public struct PatternTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.pattern
    
    let tokenizer = typeKey.rawValue
    
    public var pattern: String? = nil
    public var flags: String? = nil
    public var group: Int? = nil

    enum CodingKeys: String, CodingKey {
        case pattern
        case flags
        case group
    }
}
