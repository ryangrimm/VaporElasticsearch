
import Foundation

public struct SimpleAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.simple
    
    let analyzer = typeKey.rawValue
    
    public init() {}
}
