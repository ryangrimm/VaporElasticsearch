
import Foundation

public struct ThaiTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.thai
    
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
