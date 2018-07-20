
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
    
    public init(pattern: String? = nil, flags: String? = nil, group: Int? = nil) {
        self.pattern = pattern
        self.flags = flags
        self.group = group
    }
}
