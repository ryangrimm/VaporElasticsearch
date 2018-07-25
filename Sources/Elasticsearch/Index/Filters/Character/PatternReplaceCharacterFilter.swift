
import Foundation

/**
 The pattern replace character filter uses a regular expression to match characters which should be replaced with the specified replacement string. The replacement string can refer to capture groups in the regular expression.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-pattern-replace-charfilter.html)
 */
public struct PatternReplaceCharacterFilter: CharacterFilter {
    /// :nodoc:
    public static var typeKey = CharacterFilterType.patternReplace
    
    public let type = typeKey.rawValue
    public let name: String
    public var pattern: String
    public var replacement: String
    public var flags: String?
    
    enum CodingKeys: String, CodingKey {
        case type
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
