
import Foundation

/**
 The keyword analyzer is a “noop” analyzer which returns the entire input string as a single token.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/analysis-keyword-analyzer.html)
 */
public struct KeywordAnalyzer: Analyzer, BuiltinAnalyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.keyword
    
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
