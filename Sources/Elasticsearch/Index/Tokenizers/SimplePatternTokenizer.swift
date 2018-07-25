
import Foundation

public struct SimplePatternTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.simplePattern
    
    public let type = typeKey.rawValue
    public let name: String
    public let pattern: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case pattern
    }
    
    public init(name: String, pattern: String) {
        self.name = name
        self.pattern = pattern
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
    }
}
