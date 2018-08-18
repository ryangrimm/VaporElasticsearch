
import Foundation

public struct ModelTokenCount: ModelType, ExpressibleByStringLiteral, CustomStringConvertible {
    public typealias StringLiteralType = String
    
    public var value: String
    
    public init(stringLiteral value: String) {
        self.value = value
    }
    
    public var description: String {
        return value
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}

extension ModelTokenCount {
    public static let backingType: Mappable.Type = Mapping.self
    
    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.tokenCount
        public var analyzer: String?
        public var enablePositionIncrements: Bool?
        public var boost: Float?
        public var docValues: Bool?
        public var index: Bool?
        public var nullValue: Bool?
        public var store: Bool?
        
        enum CodingKeys: String, CodingKey {
            case type
            case analyzer
            case enablePositionIncrements = "enable_position_increments"
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
                    analyzer: String? = nil,
                    enablePositionIncrements: Bool? = nil,
                    boost: Float? = nil,
                    nullValue: Bool? = nil) {
            
            self.docValues = docValues
            self.index = index
            self.store = store
            self.analyzer = analyzer
            self.enablePositionIncrements = enablePositionIncrements
            self.boost = boost
            self.nullValue = nullValue
        }
    }
}
