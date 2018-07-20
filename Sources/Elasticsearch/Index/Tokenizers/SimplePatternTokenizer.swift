
import Foundation

public struct SimplePatternTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.simplePattern
    
    let tokenizer = typeKey.rawValue
    
    public var pattern: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case pattern
    }
    
    public init(pattern: String? = nil) {
        self.pattern = pattern
    }
}
