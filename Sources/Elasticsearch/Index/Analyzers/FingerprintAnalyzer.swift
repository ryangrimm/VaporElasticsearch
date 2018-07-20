
import Foundation

public struct FingerprintAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.custom
    
    let analyzer = typeKey.rawValue
    
    public var separator: String? = nil
    public var maxOutputSize: Int? = nil
    public var stopwords: String? = nil
    public var stopwordsPath: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case separator
        case maxOutputSize = "max_output_size"
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init(separator: String? = nil,
                maxOutputSize: Int? = nil,
                stopwords: String? = nil,
                stopwordsPath: String? = nil) {
        
        self.separator = separator
        self.maxOutputSize = maxOutputSize
        self.stopwords = stopwords
        self.stopwordsPath = stopwordsPath
    }
}
