
import Foundation

public struct LengthFilter: TokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.length
    
    public let type = typeKey.rawValue
    public let name: String
    public var min: Int
    public var max: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case min
        case max
    }
    
    public init(name: String, min: Int, max: Int) {
        self.name = name
        self.min = min
        self.max = max
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.min = try container.decode(Int.self, forKey: .min)
        self.max = try container.decode(Int.self, forKey: .max)
    }
}
