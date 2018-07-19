
import Foundation

public struct StopAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.stop
    
    let analyzer = typeKey.rawValue

    public var stopwords: [String]? = nil
    public var stopwordsPath: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
}
