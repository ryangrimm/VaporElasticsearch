
import Foundation

/**
 The kstem token filter is a high performance filter for english. All terms must already be lowercased (use lowercase filter) for this filter to work correctly.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-kstem-tokenfilter.html)
 */
public struct KStemFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.kStem
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
