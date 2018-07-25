
import Foundation

/**
 A token filter of type uppercase that normalizes token text to upper case.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-uppercase-tokenfilter.html)
 */
public struct UppercaseFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.uppercase
    
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
