
import Foundation

public struct HTMLStripCharacterFilter: CharacterFilter, BuiltinCharacterTokenFilter {
    /// :nodoc:
    public static var typeKey = CharacterFilterType.htmlStrip
    
    public let type = typeKey.rawValue
    public let name: String
    public let escapedTags: [String]?
    
    let isCustom: Bool

    enum CodingKeys: String, CodingKey {
        case type
        case escapedTags = "escaped_tags"
    }
    
    public init() {
        self.name = type
        self.isCustom = false
        self.escapedTags = nil
    }
    
    public init(name: String, escapedTags: [String]) {
        self.name = name
        self.escapedTags = escapedTags
        self.isCustom = true
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        if self.isCustom {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encode(escapedTags, forKey: .escapedTags)
        }
        else {
            var container = encoder.singleValueContainer()
            try container.encode(type)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.escapedTags = try container.decodeIfPresent([String].self, forKey: .escapedTags)
        self.isCustom = true
    }
}
