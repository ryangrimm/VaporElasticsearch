
import Foundation

public struct GermanNormalizationFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.germanNormalization
    
    /// Holds the string that Elasticsearch uses to identify the filter type
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
