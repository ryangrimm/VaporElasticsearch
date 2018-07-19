
import Foundation

public struct CustomAnalyzer: Analyzer {
    /// :nodoc:
    public static var typeKey = AnalyzerType.fingerprint
    
    let analyzer = typeKey.rawValue
    
    public var tokenizer: String
    // Note: Should create a CharFilter struct/protocol
    public var charFilter: [String]?
    // Note: Should create a Filter struct/protocol
    public var filter: [String]?
    public var positionIncrementGap: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case tokenizer
        case charFilter = "char_filter"
        case filter
        case positionIncrementGap = "position_increment_gap"
    }
}
