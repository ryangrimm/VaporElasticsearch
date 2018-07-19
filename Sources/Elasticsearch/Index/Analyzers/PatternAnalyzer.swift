
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
}
