import Foundation


public protocol Analyzer: Codable {
    static var typeKey: AnalyzerType { get }
    var name: String { get }
}

/// :nodoc:
public enum AnalyzerType: String, Codable {
    case none
    case standard
    case simple
    case whitespace
    case stop
    case keyword
    case pattern
    case fingerprint
    case custom
    
    var metatype: Analyzer.Type {
        switch self {
        case .none:
            return TempAnalyzer.self
        case .standard:
            return StandardAnalyzer.self
        case .simple:
            return SimpleAnalyzer.self
        case .whitespace:
            return WhitespaceAnalyzer.self
        case .stop:
            return StopAnalyzer.self
        case .keyword:
            return KeywordAnalyzer.self
        case .pattern:
            return PatternAnalyzer.self
        case .fingerprint:
            return FingerprintAnalyzer.self
        case .custom:
            return CustomAnalyzer.self
        }
    }
}

public struct AnyAnalyzer : Codable {
    var base: Analyzer
    
    init(_ base: Analyzer) {
        self.base = base
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        
        let type = try container.decode(AnalyzerType.self, forKey: DynamicKey(stringValue: "type")!)
        self.base = try type.metatype.init(from: decoder)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

/// :nodoc:
internal struct TempAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.none
    
    let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    internal init(name: String) {
        self.name = name
    }
}
