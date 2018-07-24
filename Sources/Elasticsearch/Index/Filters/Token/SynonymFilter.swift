
import Foundation

public struct SynonymFilter: TokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.synonym
    
    public let type = typeKey.rawValue
    public let name: String
    public var synonyms: [String]?
    public var synonymsPath: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case synonyms
        case synonymsPath = "synonyms_path"
    }
    
    public init(name: String, synonyms: [String]) {
        self.name = name
        self.synonyms = synonyms
        self.synonymsPath = nil
    }
    
    public init(name: String, synonymsPath: String) {
        self.name = name
        self.synonyms = nil
        self.synonymsPath = synonymsPath
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.synonyms = try container.decodeIfPresent([String].self, forKey: .synonyms)
        self.synonymsPath = try container.decodeIfPresent(String.self, forKey: .synonymsPath)
    }
}
