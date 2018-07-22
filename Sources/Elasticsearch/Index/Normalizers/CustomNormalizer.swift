import Foundation

public struct CustomNormalizer: Normalizer {
    /// :nodoc:
    public static var typeKey = NormalizerType.custom

    let type = typeKey.rawValue
    
    public let name: String
    public var charFilter: [String]?
    public var filter: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case charFilter = "char_filter"
        case filter
    }
    
    public init(name: String, charFilter:[String]? = nil, filter: [String]? = nil) {
        self.name = name
        self.charFilter = charFilter
        self.filter = filter
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.charFilter = try container.decodeIfPresent([String].self, forKey: .charFilter)
        self.filter = try container.decodeIfPresent([String].self, forKey: .filter)
    }
}
