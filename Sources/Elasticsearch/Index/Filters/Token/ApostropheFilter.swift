
import Foundation

/**
 The apostrophe token filter strips all characters after an apostrophe, including the apostrophe itself.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-apostrophe-tokenfilter.html)
 */
public struct ApostropheFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.apostrophe
    
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
