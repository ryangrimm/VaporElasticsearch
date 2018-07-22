
import Foundation

public struct ClassicTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.classic
    
    let tokenizer = typeKey.rawValue
    
    public let name: String

    public var maxTokenLength: Int?
    
    enum CodingKeys: String, CodingKey {
        case maxTokenLength = "max_token_length"
    }
    
    public init(name: String, maxTokenLength: Int? = nil) {
        self.name = name
        self.maxTokenLength = maxTokenLength
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.maxTokenLength = try container.decodeIfPresent(Int.self, forKey: .maxTokenLength)
    }
}
