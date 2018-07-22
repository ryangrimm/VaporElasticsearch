
import Foundation

public struct FingerprintAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.custom
    
    let analyzer = typeKey.rawValue
    
    public let name: String
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
    
    public init(name: String,
                separator: String? = nil,
                maxOutputSize: Int? = nil,
                stopwords: String? = nil,
                stopwordsPath: String? = nil) {
        
        self.name = name
        self.separator = separator
        self.maxOutputSize = maxOutputSize
        self.stopwords = stopwords
        self.stopwordsPath = stopwordsPath
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.separator = try container.decodeIfPresent(String.self, forKey: .separator)
        self.maxOutputSize = try container.decodeIfPresent(Int.self, forKey: .maxOutputSize)
        self.stopwords = try container.decodeIfPresent(String.self, forKey: .stopwords)
        self.stopwordsPath = try container.decodeIfPresent(String.self, forKey: .stopwordsPath)
    }
}
