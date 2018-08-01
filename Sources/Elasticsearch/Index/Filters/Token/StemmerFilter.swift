
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
    
    public init<T: StemmerLanguage>(language: T) where T.RawValue == String {
        self.name = language.rawValue
    }

    public init() {
        self.init(language: StemmerFilter.Language.English.english)
    }
}
