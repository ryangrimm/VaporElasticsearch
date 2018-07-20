
import Foundation

public struct StandardAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.standard
    
    let analyzer = typeKey.rawValue
    
    public var maxTokenLength: Int? = nil
    public var stopwords: [String]? = nil
    public var stopwordsPath: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case maxTokenLength = "max_token_length"
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init(stopwords: [String]? = nil,
                stopwordsPath: String? = nil,
                maxTokenLength: Int? = nil) {
        
        self.stopwords = stopwords
        self.stopwordsPath = stopwordsPath
        self.maxTokenLength = maxTokenLength
    }
}
