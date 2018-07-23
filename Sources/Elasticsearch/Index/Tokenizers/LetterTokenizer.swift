
import Foundation

public struct LetterTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.letter
    
    let type = typeKey.rawValue
    
    public let name: String
    
    public init() {
        self.name = type
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(type)
    }
}
