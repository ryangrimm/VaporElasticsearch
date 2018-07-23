
import Foundation

public struct PorterStemFilter: BasicTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.porterStem
    
    public let type = typeKey.rawValue
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
