
import Foundation

public struct KeywordAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.keyword
    
    let analyzer = typeKey.rawValue
}
