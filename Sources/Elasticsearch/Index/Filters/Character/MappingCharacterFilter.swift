
import Foundation

public struct MappingCharacterFilter: CharacterFilter {
    /// :nodoc:
    public static var typeKey = CharacterFilterType.mapping
    
    let type = typeKey.rawValue
    
    public let name: String
    public var mappings: [String: String]? = nil
    public var mappingsPath: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case type
        case mappings
        case mappingsPath = "mappings_path"
    }
    
    public init(name: String, mappings: [String: String]) {
        self.name = name
        self.mappings = mappings
        self.mappingsPath = nil
    }
    
    public init(name: String, mappingsPath: String) {
        self.name = name
        self.mappings = nil
        self.mappingsPath = mappingsPath
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.mappings = try container.decodeIfPresent([String: String].self, forKey: .mappings)
        self.mappingsPath = try container.decodeIfPresent(String.self, forKey: .mappingsPath)
    }
}
