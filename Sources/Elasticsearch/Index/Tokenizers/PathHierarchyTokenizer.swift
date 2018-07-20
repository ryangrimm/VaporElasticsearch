
import Foundation

public struct PathHierarchyTokenizer: Tokenizer {
    /// :nodoc:
    public static var typeKey = TokenizerType.pathHierarchy
    
    let tokenizer = typeKey.rawValue
    
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
    
    public init(delimiter: String? = nil, replacement: String? = nil, bufferSize: Int? = nil, reverse: Bool? = nil, skip: Int? = nil) {
        self.delimiter = delimiter
        self.replacement = replacement
        self.bufferSize = bufferSize
        self.reverse = reverse
        self.skip = skip
    }
}
