
import Foundation

public struct StandardAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.standard
    
    let analyzer = typeKey.rawValue
    
    public var stopwords: String
    
    public init(stopwords: String) {
        self.stopwords = stopwords
    }
}
