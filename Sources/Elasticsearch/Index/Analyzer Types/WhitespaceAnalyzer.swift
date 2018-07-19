
import Foundation

public struct WhitespaceAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.whitespace
    
    let analyzer = typeKey.rawValue
}
