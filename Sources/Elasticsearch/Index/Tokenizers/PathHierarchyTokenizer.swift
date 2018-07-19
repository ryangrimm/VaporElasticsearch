
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
}
