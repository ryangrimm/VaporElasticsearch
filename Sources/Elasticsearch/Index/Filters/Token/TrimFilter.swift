
import Foundation

/**
 The trim token filter trims the whitespace surrounding a token.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-trim-tokenfilter.html)
 */
public struct TrimFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.trim
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
