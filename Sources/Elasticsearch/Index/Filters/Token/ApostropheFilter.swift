
import Foundation

public struct ApostropheFilter: BasicTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.apostrophe
    
    public let type = typeKey.rawValue
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
