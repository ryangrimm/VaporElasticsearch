
import Foundation

public typealias ModelDate = Date
extension Date: ModelType {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.date
        public var boost: Float? = nil
        public var docValues: Bool? = nil
        public var format: String? = nil
        public var locale: String? = nil
        public var ignoreMalformed: Bool? = nil
        public var index: Bool? = nil
        public var nullValue: Bool? = nil
        public var store: Bool? = nil
        
        enum CodingKeys: String, CodingKey {
            case type
            case boost
            case docValues = "doc_values"
            case format
            case locale
            case ignoreMalformed = "ignoreMalformed"
            case index
            case nullValue = "null_value"
            case store
        }
        
        public init() { }
        
        public init(format: String? = nil,
                    docValues: Bool? = nil,
                    index: Bool? = nil,
                    store: Bool? = nil,
                    boost: Float? = nil,
                    locale: String? = nil,
                    ignoreMalformed: Bool? = nil,
                    nullValue: Bool? = nil) {
            
            self.boost = boost
            self.docValues = docValues
            self.format = format
            self.locale = locale
            self.ignoreMalformed = ignoreMalformed
            self.index = index
            self.nullValue = nullValue
            self.store = store
        }
    }
}
