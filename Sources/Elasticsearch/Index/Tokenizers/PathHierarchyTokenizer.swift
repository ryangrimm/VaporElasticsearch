
import Foundation

/**
 The path hierarchy tokenizer takes a hierarchical value like a filesystem path, splits on the path separator, and emits a term for each component in the tree.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-pathhierarchy-tokenizer.html)
 */
public struct PathHierarchyTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.pathHierarchy
    
    public let type = typeKey.rawValue
    public let name: String
    public let delimiter: String?
    public let replacement: String?
    public let bufferSize: Int?
    public let reverse: Bool?
    public let skip: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case delimiter
        case replacement
        case bufferSize = "buffer_size"
        case reverse
        case skip
    }
    
    public init(name: String, delimiter: String, replacement: String? = nil, bufferSize: Int? = nil, reverse: Bool? = nil, skip: Int? = nil) {
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
