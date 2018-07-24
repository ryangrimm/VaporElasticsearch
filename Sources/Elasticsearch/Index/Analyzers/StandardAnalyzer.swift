
import Foundation

public struct StandardAnalyzer: Analyzer, BuiltinAnalyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.standard
    
    public let type = typeKey.rawValue
    public let name: String
    public var maxTokenLength: Int? = nil
    public var stopwords: [String]? = nil
    public var stopwordsPath: String? = nil
    
    let isCustom: Bool
    
    enum CodingKeys: String, CodingKey {
        case type
        case maxTokenLength = "max_token_length"
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init() {
        self.name = type
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
