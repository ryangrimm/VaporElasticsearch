
import Foundation

public struct EdgeNGramFilter: TokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.edgeNGram
    
    public let type = typeKey.rawValue
    public let name: String
    public let minGram: Int
    public let maxGram: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case minGram = "min_gram"
        case maxGram = "max_gram"
    }
    
    public init(name: String, minGram: Int, maxGram: Int) {
        self.name = name
        self.minGram = minGram
        self.maxGram = maxGram
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.minGram = try container.decode(Int.self, forKey: .minGram)
        self.maxGram = try container.decode(Int.self, forKey: .maxGram)
    }
}
