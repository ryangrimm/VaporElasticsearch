
import Foundation

/**
 The keyword tokenizer is a “noop” tokenizer that accepts whatever text it is given and outputs the exact same text as a single term. It can be combined with token filters to normalise output, e.g. lower-casing email addresses.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-keyword-tokenizer.html)
 */
public struct KeywordTokenizer: Tokenizer, BultinTokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.keyword
    
    public let type = typeKey.rawValue
    public let name: String
    public var bufferSize: Int?
    
    let isCustom: Bool
    
    enum CodingKeys: String, CodingKey {
        case type
        case bufferSize = "buffer_size"
    }
    
    public init() {
        self.name = self.type
        self.bufferSize = nil
        self.isCustom = false
    }
    
    public init(name: String, bufferSize: Int) {
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
        self.isCustom = true
    }
}
