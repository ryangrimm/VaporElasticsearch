
import Foundation

public typealias ModelBool = Bool
extension Bool: ModelType {
    public static let backingType: Mappable.Type = Mapping.self
    
    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public var type = MapType.boolean
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
