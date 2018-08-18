
import Foundation

public enum IPAddress: Codable, CustomStringConvertible {
    case v4(Int8, Int8, Int8, Int8)
    case v6(String)
    
    public var description: String {
        switch self {
        case .v4(let octet1, let octet2, let octet3, let octet4):
            return "\(octet1).\(octet2).\(octet3).\(octet4)"
        case .v6(let value):
            return value
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let rawValue = try container.decode(String.self)
        if rawValue.contains(":") == false {
            let v4Bits = rawValue.split(separator: ".", maxSplits: 3, omittingEmptySubsequences: true)
            if v4Bits.count == 4 {
                if let octet1 = Int8(v4Bits[0]),
                    let octet2 = Int8(v4Bits[1]),
                    let octet3 = Int8(v4Bits[2]),
                    let octet4 = Int8(v4Bits[3]) {
                    self = .v4(octet1, octet2, octet3, octet4)
                    return
                }
            }
        }
        
        self = .v6(rawValue)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

public typealias ModelIPAddress = IPAddress
extension ModelIPAddress: ModelType {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.ipAddress
        public var boost: Float? = nil
        public var docValues: Bool? = nil
        public var index: Bool? = nil
        public var nullValue: Bool? = nil
        public var store: Bool? = nil
        
        enum CodingKeys: String, CodingKey {
            case type
            case boost
            case docValues = "doc_values"
            case index
            case nullValue = "null_value"
            case store
        }
        
        public init() { }
        
        public init(docValues: Bool? = nil,
                    index: Bool? = nil,
                    store: Bool? = nil,
                    boost: Float? = nil,
                    nullValue: Bool? = nil) {
            
            self.boost = boost
            self.docValues = docValues
            self.index = index
            self.nullValue = nullValue
            self.store = store
        }
    }
}
