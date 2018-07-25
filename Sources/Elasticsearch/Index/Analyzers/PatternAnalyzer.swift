
import Foundation

/**
 The pattern analyzer uses a regular expression to split the text into terms. The regular expression should match the token separators not the tokens themselves. The regular expression defaults to \W+ (or all non-word characters).
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/analysis-pattern-analyzer.html)
 */
public struct PatternAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.pattern
    
    /// Holds the string that Elasticsearch uses to identify the analyzer type
    public let type = typeKey.rawValue
    public let name: String
    public let pattern: String?
    public let flags: String?
    public let lowercase: Bool?
    public let stopwords: [String]?
    public let stopwordsPath: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case pattern
        case flags
        case lowercase
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init(name: String,
                pattern: String? = nil,
                flags: String? = nil,
                lowercase: Bool? = nil,
                stopwords: [String]) {
        
        self.name = name
        self.pattern = pattern
        self.flags = flags
        self.lowercase = lowercase
        self.stopwords = stopwords
        self.stopwordsPath = nil
    }
    
    public init(name: String,
                pattern: String? = nil,
                flags: String? = nil,
                lowercase: Bool? = nil,
                stopwordsPath: String) {
        
        self.name = name
        self.pattern = pattern
        self.flags = flags
        self.lowercase = lowercase
        self.stopwords = nil
        self.stopwordsPath = stopwordsPath
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
        self.flags = try container.decodeIfPresent(String.self, forKey: .flags)
        self.lowercase = try container.decodeIfPresent(Bool.self, forKey: .lowercase)
        self.stopwords = try container.decodeIfPresent([String].self, forKey: .stopwords)
        self.stopwordsPath = try container.decodeIfPresent(String.self, forKey: .stopwordsPath)
    }
}
