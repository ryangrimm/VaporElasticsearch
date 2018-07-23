
import Foundation

public struct ClassicFilter: BasicTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.classic
    
    public let type = typeKey.rawValue
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
