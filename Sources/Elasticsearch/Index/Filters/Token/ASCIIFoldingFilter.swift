
import Foundation

public struct ASCIIFoldingFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.asciiFolding
    
    public let type = typeKey.rawValue
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
