
import Foundation

/**
 A filter that provides access to (almost) all of the available stemming token filters through a single unified interface.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-stemmer-tokenfilter.html)
 */
public struct StemmerFilter: TokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.stemmer
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    public let language: Language
    
    public init(language: Language, name: String? = nil) {
        self.language = language
        self.name = name ?? StemmerFilter.defaultStemmerName(language: language)
    }

    public init() {
        self.init(language: Language.english)
    }

    /// returns stemmer name
    internal static func defaultStemmerName(language: Language) -> String {
        return "\(StemmerFilter.typeKey.rawValue)_\(language.rawValue)"
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case type
        case language = "name"
    }
    /// :nodoc:
    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.language = try container.decode(Language.self, forKey: CodingKeys.language)
        self.name = StemmerFilter.defaultStemmerName(language: self.language)
    }
}
