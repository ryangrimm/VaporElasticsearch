
import Foundation

public struct StandardAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.standard
    
    let type = typeKey.rawValue
    
    public let name: String
    public var maxTokenLength: Int? = nil
    public var stopwords: [String]? = nil
    public var stopwordsPath: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case maxTokenLength = "max_token_length"
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init(name: String,
                stopwords: [String]? = nil,
                stopwordsPath: String? = nil,
                maxTokenLength: Int? = nil) {
        
        self.name = name
        self.stopwords = stopwords
        self.stopwordsPath = stopwordsPath
        self.maxTokenLength = maxTokenLength
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.maxTokenLength = try container.decodeIfPresent(Int.self, forKey: .maxTokenLength)
        self.stopwords = try container.decodeIfPresent([String].self, forKey: .stopwords)
        self.stopwordsPath = try container.decodeIfPresent(String.self, forKey: .stopwordsPath)
    }
}
