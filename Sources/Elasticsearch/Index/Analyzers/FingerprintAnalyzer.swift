
import Foundation

/**
 The fingerprint analyzer implements a fingerprinting algorithm which is used by the OpenRefine project to assist in clustering.
 
 Input text is lowercased, normalized to remove extended characters, sorted, deduplicated and concatenated into a single token. If a stopword list is configured, stop words will also be removed.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/analysis-fingerprint-analyzer.html)
 */
public struct FingerprintAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.fingerprint
    
    /// Holds the string that Elasticsearch uses to identify the analyzer type
    public let type = typeKey.rawValue
    public let name: String
    public let separator: String?
    public let maxOutputSize: Int?
    public let stopwords: [String]?
    public let stopwordsPath: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case separator
        case maxOutputSize = "max_output_size"
        case stopwords
        case stopwordsPath = "stopwords_path"
    }
    
    public init(name: String,
                separator: String? = nil,
                maxOutputSize: Int? = nil,
                stopwords: [String]) {
        
        self.name = name
        self.separator = separator
        self.maxOutputSize = maxOutputSize
        self.stopwords = stopwords
        self.stopwordsPath = nil
    }
    
    public init(name: String,
                separator: String? = nil,
                maxOutputSize: Int? = nil,
                stopwordsPath: String) {
        
        self.name = name
        self.separator = separator
        self.maxOutputSize = maxOutputSize
        self.stopwords = nil
        self.stopwordsPath = stopwordsPath
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.separator = try container.decodeIfPresent(String.self, forKey: .separator)
        self.maxOutputSize = try container.decodeIfPresent(Int.self, forKey: .maxOutputSize)
        self.stopwords = try container.decodeIfPresent([String].self, forKey: .stopwords)
        self.stopwordsPath = try container.decodeIfPresent(String.self, forKey: .stopwordsPath)
    }
}
