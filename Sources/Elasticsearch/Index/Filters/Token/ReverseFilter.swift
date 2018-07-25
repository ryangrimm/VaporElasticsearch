
import Foundation

/**
 A token filter of type reverse that simply reverses each token.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-reverse-tokenfilter.html)
 */
public struct ReverseFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.reverse
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
