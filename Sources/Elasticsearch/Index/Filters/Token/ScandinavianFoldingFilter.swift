
import Foundation

public struct ScandinavianFoldingFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.scandinavianFolding
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
