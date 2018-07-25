
import Foundation

/**
 The decimal digit token filter folds unicode digits to 0-9
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-decimal-digit-tokenfilter.html)
 */
public struct DecimalDigitFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.decimalDigit
    
    public let type = typeKey.rawValue    
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
