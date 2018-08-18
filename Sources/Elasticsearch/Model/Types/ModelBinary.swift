
import Foundation

public typealias ModelBinary = Data
extension ModelBinary: ModelType {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public var type = MapType.binary
        public var docValues: Bool? = nil
        public var store: Bool? = nil
        
        enum CodingKeys: String, CodingKey {
            case type
            case docValues = "doc_values"
            case store
        }
        
        public init() { }
        
        public init(docValues: Bool? = nil, store: Bool? = nil) {
            self.docValues = docValues
            self.store = store
        }
    }
}
