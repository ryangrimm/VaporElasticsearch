
import Foundation

/**
 The standard analyzer is the default analyzer which is used if none is specified. It provides grammar based tokenization (based on the Unicode Text Segmentation algorithm, as specified in Unicode Standard Annex #29) and works well for most languages.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/analysis-standard-analyzer.html)
 */
public struct StandardAnalyzer: Analyzer, BuiltinAnalyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.standard
    
    /// Holds the string that Elasticsearch uses to identify the analyzer type
    public let type = typeKey.rawValue
    public let name: String
    public let maxTokenLength: Int?
    public let stopwords: [String]?
    public let stopwordsPath: String?
    
    let isCustom: Bool
    
    enum CodingKeys: String, CodingKey {
        case type
        case maxTokenLength = "max_token_length"
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init() {
        self.name = type
        self.maxTokenLength = nil
        self.stopwords = nil
        self.stopwordsPath = nil
        self.isCustom = false
    }
    
    public init(name: String, stopwords: [String]? = nil, maxTokenLength: Int? = nil) {
        self.name = name
        self.stopwords = stopwords
        self.stopwordsPath = nil
        self.maxTokenLength = maxTokenLength
        self.isCustom = true
    }
    
    public init(name: String, stopwordsPath: String? = nil, maxTokenLength: Int? = nil) {
        self.name = name
        self.stopwords = nil
        self.stopwordsPath = stopwordsPath
        self.maxTokenLength = maxTokenLength
        self.isCustom = true
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        if self.isCustom {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encodeIfPresent(stopwords, forKey: .stopwords)
            try container.encodeIfPresent(stopwordsPath, forKey: .stopwordsPath)
            try container.encodeIfPresent(maxTokenLength, forKey: .maxTokenLength)
        }
        else {
            var container = encoder.singleValueContainer()
            try container.encode(type)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.maxTokenLength = try container.decodeIfPresent(Int.self, forKey: .maxTokenLength)
        self.stopwords = try container.decodeIfPresent([String].self, forKey: .stopwords)
        self.stopwordsPath = try container.decodeIfPresent(String.self, forKey: .stopwordsPath)
        self.isCustom = true
    }
}
