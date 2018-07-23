
import Foundation

public struct TrimFilter: BasicTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.trim
    
    public let type = typeKey.rawValue
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
