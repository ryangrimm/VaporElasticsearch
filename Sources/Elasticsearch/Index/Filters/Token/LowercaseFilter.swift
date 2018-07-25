
import Foundation

public struct LowercaseFilter: TokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.lowercase
    
    public let type = typeKey.rawValue
    public let name: String
    public let language: Language?
    
    let isCustom: Bool
    
    public enum Language: String, Codable {
        case greek
        case irish
        case turkish
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case language
    }
    
    public init() {
        self.name = type
        self.language = nil
        self.isCustom = false
    }
    
    public init(name: String, language: Language) {
        self.name = name
        self.language = language
        self.isCustom = true
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        if self.isCustom {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encode(language, forKey: .language)
        }
        else {
            var container = encoder.singleValueContainer()
            try container.encode(type)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.language = try container.decode(Language.self, forKey: .language)
        self.isCustom = true
    }
}
