
import Foundation

public struct SimpleAnalyzer: Analyzer, BuiltinAnalyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.simple
    
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
