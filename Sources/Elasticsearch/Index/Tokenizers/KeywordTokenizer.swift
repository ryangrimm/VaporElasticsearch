
import Foundation

public struct KeywordTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.keyword
    
    let type = typeKey.rawValue
    
    public let name: String
    public var bufferSize: Int? = nil
    
    var isCustom = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case bufferSize = "buffer_size"
    }
    
    public init() {
        self.name = self.type
        self.isCustom = false
    }
    
    public init(name: String, bufferSize: Int? = nil) {
        self.name = name
        self.bufferSize = bufferSize
        self.isCustom = true
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        if self.isCustom {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encode(bufferSize, forKey: .bufferSize)
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
        
        self.bufferSize = try container.decodeIfPresent(Int.self, forKey: .bufferSize)
    }
}
