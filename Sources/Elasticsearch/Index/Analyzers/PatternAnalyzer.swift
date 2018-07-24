
import Foundation

public struct PatternAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.pattern
    
    public let type = typeKey.rawValue
    public let name: String
    public var pattern: String? = nil
    public var flags: String? = nil
    public var lowercase: Bool? = nil
    public var stopwords: [String]? = nil
    public var stopwordsPath: String? = nil
    
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
