
import Foundation

public struct KeywordTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.keyword
    
    let tokenizer = typeKey.rawValue
    
    public let name: String

    public var bufferSize: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case bufferSize = "buffer_size"
    }
    
    public init(name: String, bufferSize: Int? = nil) {
        self.name = name
        self.bufferSize = bufferSize
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.bufferSize = try container.decodeIfPresent(Int.self, forKey: .bufferSize)
    }
}
