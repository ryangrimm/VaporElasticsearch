
import Foundation

public typealias ModelFloat = Float
extension Float: ModelType {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type: MapType
        public var overrideType: MapType? {
            didSet {
                if overrideType != MapType.scaledFloat && overrideType != MapType.halfFloat && overrideType != MapType.float {
                    overrideType = oldValue
                }
            }
        }
        
        public var coerce: Bool? = nil
        public var boost: Float? = nil
        public var docValues: Bool? = nil
        public var ignoreMalformed: Bool? = nil
        public var index: Bool? = nil
        public var nullValue: Float? = nil
        public var store: Bool? = nil
        
        public var scalingFactor: Int? = 0
        
        enum CodingKeys: String, CodingKey {
            case type
            case coerce
            case boost
            case docValues = "doc_values"
            case ignoreMalformed = "ignore_malformed"
            case index
            case nullValue = "null_value"
            case store
            case scalingFactor = "scaling_factor"
        }
        
        public init() {
            self.type = MapType.float
        }
        
        public init(scalingFactor: Int? = nil,
                    docValues: Bool? = nil,
                    index: Bool? = nil,
                    store: Bool? = nil,
                    boost: Float? = nil,
                    coerce: Bool? = nil,
                    ignoreMalformed: Bool? = nil,
                    nullValue: Float? = nil) {
            
            self.scalingFactor = scalingFactor
            self.coerce = coerce
            self.boost = boost
            self.docValues = docValues
            self.ignoreMalformed = ignoreMalformed
            self.index = index
            self.nullValue = nullValue
            self.store = store
            self.type = MapType.float
        }
        
        /// :nodoc:
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            if type == MapType.scaledFloat {
                try container.encodeIfPresent(scalingFactor, forKey: .scalingFactor)
            }
            try container.encodeIfPresent(coerce, forKey: .coerce)
            try container.encodeIfPresent(boost, forKey: .boost)
            try container.encodeIfPresent(docValues, forKey: .docValues)
            try container.encodeIfPresent(ignoreMalformed, forKey: .ignoreMalformed)
            try container.encodeIfPresent(index, forKey: .index)
            try container.encodeIfPresent(nullValue, forKey: .nullValue)
            try container.encodeIfPresent(store, forKey: .store)
        }
    }
}
