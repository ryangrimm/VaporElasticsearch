import Foundation

/// :nodoc:
public protocol Analyzer: Codable {
    static var typeKey: AnalyzerType { get }
    var name: String { get }
}

/// :nodoc:
public protocol BuiltinAnalyzer {
    init()
}

/// :nodoc:
public enum AnalyzerType: String, Codable {
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
    
    enum Builtins: String, CodingKey {
        case standard
        case simple
        case whitespace
        case keyword
        
        var metatype: BuiltinAnalyzer.Type {
            switch self {
            case .standard:
                return StandardAnalyzer.self
            case .simple:
                return SimpleAnalyzer.self
            case .whitespace:
                return WhitespaceAnalyzer.self
            case .keyword:
                return KeywordAnalyzer.self
            }
        }
    }
}

/// :nodoc:
internal struct AnyAnalyzer : Codable {
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
