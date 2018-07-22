
import Foundation

public struct PatternReplaceCharacterFilter: CharacterFilter {
    /// :nodoc:
    public static var typeKey = CharacterFilterType.mapping
    
    let type = typeKey.rawValue
    
    public let name: String
    public var pattern: String
    public var replacement: String
    public var flags: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case pattern
        case replacement
        case flags
    }
    
    public init(name: String, pattern: String, replacement: String, flags: String? = nil) {
        self.name = name
        self.pattern = pattern
        self.replacement = replacement
        self.flags = flags
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.pattern = try container.decode(String.self, forKey: .pattern)
        self.replacement = try container.decode(String.self, forKey: .replacement)
        self.flags = try container.decodeIfPresent(String.self, forKey: .flags)
    }
}
