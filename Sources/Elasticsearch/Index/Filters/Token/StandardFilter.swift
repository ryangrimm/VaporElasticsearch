
import Foundation

/**
 A token filter of type standard that normalizes tokens extracted with the standard tokenizer.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-standard-tokenfilter.html)
 */
public struct StandardFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.standard
    
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String

    public init() {
        self.name = self.type
    }
}
