
import Foundation

/**
 The mapping character filter accepts a map of keys and values. Whenever it encounters a string of characters that is the same as a key, it replaces them with the value associated with that key.
 
 Matching is greedy; the longest pattern matching at a given point wins. Replacements are allowed to be the empty string.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-mapping-charfilter.html)
 */
public struct MappingCharacterFilter: CharacterFilter {
    /// :nodoc:
    public static var typeKey = CharacterFilterType.mapping
    
    public let type = typeKey.rawValue
    public let name: String
    public let mappings: [String: String]?
    public let mappingsPath: String?
    
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
