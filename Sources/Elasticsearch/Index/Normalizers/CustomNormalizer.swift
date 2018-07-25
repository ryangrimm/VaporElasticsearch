import Foundation
/**
 Normalizers are similar to analyzers except that they may only emit a single token. As a consequence, they do not have a tokenizer and only accept a subset of the available char filters and token filters. Only the filters that work on a per-character basis are allowed. For instance a lowercasing filter would be allowed, but not a stemming filter, which needs to look at the keyword as a whole. The current list of filters that can be used in a normalizer is following: ArabicNormalizationFilter, ASCIIFolding, BengaliNormalizationFilter, cjk_width, DecimalDigitFilter, ElisionFilter, GermanNormalizationFilter, HindiNormalizationFilter, IndicNormalizationFilter, lowercase, PersianNormalizationFilter, ScandinavianFoldingFilter, SerbianNormalizationFilter, SoraniNormalizationFilter, uppercase.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-normalizers.html)
 */
public struct CustomNormalizer: Normalizer {
    /// :nodoc:
    public static var typeKey = NormalizerType.custom

    /// Holds the string that Elasticsearch uses to identify the normalizer type
    public let type = typeKey.rawValue
    
    public let name: String
    public let charFilter: [String]?
    public let filter: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case charFilter = "char_filter"
        case filter
    }
    
    public init(name: String, filter: [String]? = nil, charFilter:[String]? = nil) {
        self.name = name
        self.filter = filter
        self.charFilter = charFilter
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.charFilter = try container.decodeIfPresent([String].self, forKey: .charFilter)
        self.filter = try container.decodeIfPresent([String].self, forKey: .filter)
    }
}
