
import Foundation

public struct PathHierarchyTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.pathHierarchy
    
    let tokenizer = typeKey.rawValue
    
    public let name: String

    public var delimiter: String? = nil
    public var replacement: String? = nil
    public var bufferSize: Int? = nil
    public var reverse: Bool? = nil
    public var skip: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case delimiter
        case replacement
        case bufferSize = "buffer_size"
        case reverse
        case skip
    }
    
    public init(name: String, delimiter: String? = nil, replacement: String? = nil, bufferSize: Int? = nil, reverse: Bool? = nil, skip: Int? = nil) {
        self.name = name
        self.delimiter = delimiter
        self.replacement = replacement
        self.bufferSize = bufferSize
        self.reverse = reverse
        self.skip = skip
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.delimiter = try container.decodeIfPresent(String.self, forKey: .delimiter)
        self.replacement = try container.decodeIfPresent(String.self, forKey: .replacement)
        self.bufferSize = try container.decodeIfPresent(Int.self, forKey: .bufferSize)
        self.reverse = try container.decodeIfPresent(Bool.self, forKey: .reverse)
        self.skip = try container.decodeIfPresent(Int.self, forKey: .skip)
    }
}
