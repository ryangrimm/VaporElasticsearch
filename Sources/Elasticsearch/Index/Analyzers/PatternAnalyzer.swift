
import Foundation

public struct PatternAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.pattern
    
    let analyzer = typeKey.rawValue
    
    public var pattern: String? = nil
    public var flags: String? = nil
    public var lowercase: Bool? = nil
    public var stopwords: [String]? = nil
    public var stopwordsPath: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case pattern
        case flags
        case lowercase
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init(pattern: String? = nil,
                flags: String? = nil,
                lowercase: Bool? = nil,
                stopwords: [String]? = nil,
                stopwordsPath: String? = nil) {
        
        self.pattern = pattern
        self.flags = flags
        self.lowercase = lowercase
        self.stopwords = stopwords
        self.stopwordsPath = stopwordsPath
    }
}
