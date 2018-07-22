import Foundation


public protocol CharacterFilter: Codable {
    static var typeKey: CharacterFilterType { get }
    var name: String { get }
}

/// :nodoc:
public enum CharacterFilterType: String, Codable {
    case none
    case htmlStrip = "html_strip"
    case mapping
    case patternReplace = "pattern_replace"
    
    var metatype: CharacterFilter.Type {
        switch self {
        case .none:
            return TempCharacterFilter.self
        case .htmlStrip:
            return HTMLStripCharacterFilter.self
        case .mapping:
            return MappingCharacterFilter.self
        case .patternReplace:
            return PatternReplaceCharacterFilter.self
        }
    }
}

public struct AnyCharacterFilter : Codable {
    var base: CharacterFilter
    
    init(_ base: CharacterFilter) {
        self.base = base
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        
        let type = try container.decode(CharacterFilterType.self, forKey: DynamicKey(stringValue: "type")!)
        self.base = try type.metatype.init(from: decoder)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

/// :nodoc:
internal struct TempCharacterFilter: CharacterFilter {
    /// :nodoc:
    public static var typeKey = CharacterFilterType.none

    let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    internal init(name: String) {
        self.name = name
    }
}

