
import Foundation

public struct ModelLongRange: ModelType {
    public var lte: Int64
    public var gte: Int64
}

extension ModelLongRange {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.longRange
        public var coerce: Bool?
        public var boost: Float?
        public var index: Bool?
        public var store: Bool?
        
        enum CodingKeys: String, CodingKey {
            case type
            case coerce
            case boost
            case index
            case store
        }
        
        public init() { }
        
        public init(index: Bool? = nil,
                    store: Bool? = nil,
                    boost: Float? = nil,
                    coerce: Bool? = nil) {
            
            self.index = index
            self.store = store
            self.boost = boost
            self.coerce = coerce
        }
    }
}
