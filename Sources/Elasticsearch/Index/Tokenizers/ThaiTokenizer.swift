
import Foundation

public struct ThaiTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.thai
    
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
