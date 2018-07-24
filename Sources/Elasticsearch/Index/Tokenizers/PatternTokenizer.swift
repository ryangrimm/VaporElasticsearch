
import Foundation

public struct PatternTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.pattern
    
    let type = typeKey.rawValue
    
    public let name: String
    
    public var pattern: String? = nil
    public var flags: String? = nil
    public var group: Int? = nil

    enum CodingKeys: String, CodingKey {
        case type
        case pattern
        case flags
        case group
    }
    
    public init(name: String, pattern: String, flags: String? = nil, group: Int? = nil) {
        self.name = name
        self.pattern = pattern
        self.flags = flags
        self.group = group
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
        self.flags = try container.decodeIfPresent(String.self, forKey: .flags)
        self.group = try container.decodeIfPresent(Int.self, forKey: .group)
    }
}
