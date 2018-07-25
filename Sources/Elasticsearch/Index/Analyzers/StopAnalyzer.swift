
import Foundation

/**
 The stop analyzer is the same as the simple analyzer but adds support for removing stop words.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/analysis-stop-analyzer.html)
 */
public struct StopAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.stop
    
    /// Holds the string that Elasticsearch uses to identify the analyzer type
    public let type = typeKey.rawValue
    public let name: String
    public let stopwords: [String]?
    public let stopwordsPath: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init(name: String, stopwords: [String]) {
        self.name = name
        self.stopwords = stopwords
        self.stopwordsPath = nil
    }
    
    public init(name: String, stopwordsPath: String? = nil) {
        self.name = name
        self.stopwords = nil
        self.stopwordsPath = stopwordsPath
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.stopwords = try container.decodeIfPresent([String].self, forKey: .stopwords)
        self.stopwordsPath = try container.decodeIfPresent(String.self, forKey: .stopwordsPath)
        
    }
}
