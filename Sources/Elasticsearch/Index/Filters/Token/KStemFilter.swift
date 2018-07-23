
import Foundation

public struct KStemFilter: BasicTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.kStem
    
    public let type = typeKey.rawValue
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
