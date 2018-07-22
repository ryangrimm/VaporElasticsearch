
import Foundation

public struct KeywordAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.keyword
    
    let analyzer = typeKey.rawValue
    
    public let name: String

    public init(name: String) {
        self.name = name
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        self.name = (decoder.codingPath.last?.stringValue)!
    }
}
