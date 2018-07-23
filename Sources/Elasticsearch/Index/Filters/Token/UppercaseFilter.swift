
import Foundation

public struct UppercaseFilter: BasicTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.uppercase
    
    public let type = typeKey.rawValue
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
