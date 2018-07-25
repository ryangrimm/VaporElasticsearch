
import Foundation

/**
 The synonym token filter allows to easily handle synonyms during the analysis process. Synonyms are configured using a configuration file.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-synonym-tokenfilter.html)
 */
public struct SynonymFilter: TokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.synonym
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    public let name: String
    public let synonyms: [String]?
    public let synonymsPath: String?
    public let format: Format
    public let expand: Bool?
    
    public enum Format: String, Codable {
        case solr
        case wordnet
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case synonyms
        case synonymsPath = "synonyms_path"
        case format
        case expand
    }
    
    public init(name: String, synonyms: [String], format: Format = .solr, expand: Bool? = nil) {
        self.name = name
        self.synonyms = synonyms
        self.synonymsPath = nil
        self.format = format
        self.expand = expand
    }
    
    public init(name: String, synonymsPath: String, format: Format = .solr, expand: Bool? = nil) {
        self.name = name
        self.synonyms = nil
        self.synonymsPath = synonymsPath
        self.format = format
        self.expand = expand
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.synonyms = try container.decodeIfPresent([String].self, forKey: .synonyms)
        self.synonymsPath = try container.decodeIfPresent(String.self, forKey: .synonymsPath)
        if let format = try container.decodeIfPresent(Format.self, forKey: .format) {
            self.format = format
        }
        else {
            self.format = .solr
        }
        self.expand = try container.decodeIfPresent(Bool.self, forKey: .expand)
    }
}
