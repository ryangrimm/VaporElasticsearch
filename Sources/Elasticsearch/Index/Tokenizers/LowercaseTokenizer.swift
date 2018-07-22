
import Foundation

public struct LowercaseTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.lowercase
    
    let tokenizer = typeKey.rawValue
    
    public let name: String

    public init(name: String) {
        self.name = name
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        self.name = (decoder.codingPath.last?.stringValue)!
    }
}
