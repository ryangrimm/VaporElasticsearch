
import Foundation

public struct Normalizer: Codable {
    let type = "custom"
    public var charFilter: [String]?
    public var filter: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case charFilter = "char_filter"
        case filter
    }
    
    public init(charFilter:[String]? = nil, filter: [String]? = nil) {
        self.charFilter = charFilter
        self.filter = filter
    }
}
