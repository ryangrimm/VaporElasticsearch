import Foundation

public protocol Normalizer: Codable {
    static var typeKey: NormalizerType { get }
    var name: String { get }
}

/// :nodoc:
public enum NormalizerType: String, Codable {
    case custom
    
    var metatype: Normalizer.Type {
        switch self {
        case .custom:
            return CustomNormalizer.self
        }
    }
}

public struct AnyNormalizer : Codable {
    var base: Normalizer
    
    init(_ base: Normalizer) {
        self.base = base
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        
        let type = try container.decode(NormalizerType.self, forKey: DynamicKey(stringValue: "type")!)
        self.base = try type.metatype.init(from: decoder)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}
