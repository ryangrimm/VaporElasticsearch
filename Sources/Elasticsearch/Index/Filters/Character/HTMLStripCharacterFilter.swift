
import Foundation

public struct HTMLStripCharacterFilter: CharacterFilter {
    /// :nodoc:
    public static var typeKey = CharacterFilterType.htmlStrip
    
    let type = typeKey.rawValue
    
    public let name: String
    public var escapedTags: [String]? = nil
    
    enum CodingKeys: String, CodingKey {
        case escapedTags = "escaped_tags"
    }
    
    public init(name: String, escapedTags: [String]? = nil) {
        self.name = name
        self.escapedTags = escapedTags
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.escapedTags = try container.decodeIfPresent([String].self, forKey: .escapedTags)
    }
}
