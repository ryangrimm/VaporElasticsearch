
import Foundation

/**
 The simple analyzer breaks text into terms whenever it encounters a character which is not a letter. All terms are lower cased.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/analysis-simple-analyzer.html)
 */
public struct SimpleAnalyzer: Analyzer, BuiltinAnalyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.simple
    
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
