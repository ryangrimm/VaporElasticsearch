import Foundation


public protocol Analyzer: Codable {
    static var typeKey: AnalyzerType { get }
}

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
}

public struct AnyAnalyzer : Codable {
    var base: Analyzer
    
    init(_ base: Analyzer) {
        self.base = base
    }
    
    private enum CodingKeys : CodingKey {
        case analyzer
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(AnalyzerType.self, forKey: .analyzer)
        self.base = try type.metatype.init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

