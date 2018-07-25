
import Foundation

/**
 The whitespace analyzer breaks text into terms whenever it encounters a whitespace character.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/analysis-whitespace-analyzer.html)
 */
public struct WhitespaceAnalyzer: Analyzer, BuiltinAnalyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.whitespace
    
    /// Holds the string that Elasticsearch uses to identify the analyzer type
    public let type = typeKey.rawValue
    public let name: String

    public init() {
        self.name = type
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(type)
    }
}
