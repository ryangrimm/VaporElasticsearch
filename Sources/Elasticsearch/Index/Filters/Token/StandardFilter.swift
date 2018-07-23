
import Foundation

public struct StandardFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.standard
    
    public let type = typeKey.rawValue
    public let name: String

    public init() {
        self.name = self.type
    }
}
