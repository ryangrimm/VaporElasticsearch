
import Foundation

public typealias ModelLong = Int64
extension Int64: ModelType {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.long
        public var coerce: Bool?
        public var boost: Float?
        public var docValues: Bool?
        public var ignoreMalformed: Bool?
        public var index: Bool?
        public var nullValue: Int64?
        public var store: Bool?
        
        enum CodingKeys: String, CodingKey {
            case type
            case coerce
            case boost
            case docValues = "doc_values"
            case ignoreMalformed = "ignore_malformed"
            case index
            case nullValue = "null_value"
            case store
        }
        
        public init() { }
        
        public init(docValues: Bool? = nil,
                    index: Bool? = nil,
                    store: Bool? = nil,
                    boost: Float? = nil,
                    coerce: Bool? = nil,
                    ignoreMalformed: Bool? = nil,
                    nullValue: Int64? = nil) {
            
            self.coerce = coerce
            self.boost = boost
            self.docValues = docValues
            self.ignoreMalformed = ignoreMalformed
            self.index = index
            self.nullValue = nullValue
            self.store = store
        }
    }
}
