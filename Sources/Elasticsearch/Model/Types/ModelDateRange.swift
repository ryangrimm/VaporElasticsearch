
import Foundation

public struct ModelDateRange: ModelType {
    public var lte: ElasticsearchDateRepresentable
    public var gte: ElasticsearchDateRepresentable
    
    enum CodingKeys: String, CodingKey {
        case lte
        case gte
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            let milliseconds = try container.decode(Int64.self, forKey: .lte)
            self.lte = Date(milliseconds: milliseconds)
        }
        catch {
            let format = try container.decode(String.self, forKey: .lte)
            self.lte = RelativeDate(format: format)
        }
        do {
            let milliseconds = try container.decode(Int64.self, forKey: .gte)
            self.gte = Date(milliseconds: milliseconds)
        }
        catch {
            let format = try container.decode(String.self, forKey: .gte)
            self.gte = RelativeDate(format: format)
        }
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let lte = lte as? Date {
            try container.encode(lte, forKey: .lte)
        }
        else {
            try container.encode(lte.stringRepresentation(), forKey: .lte)
        }
        if let gte = gte as? Date {
            try container.encode(gte, forKey: .gte)
        }
        else {
            try container.encode(gte.stringRepresentation(), forKey: .gte)
        }
    }
}

public extension ModelDateRange {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.dateRange
        public var format: String = "epoch_millis"
        public var coerce: Bool? = nil
        public var boost: Float? = nil
        public var index: Bool? = nil
        public var store: Bool? = nil
        
        enum CodingKeys: String, CodingKey {
            case type
            case format
            case coerce
            case boost
            case index
            case store
        }
        
        public init() { }
        
        public init(format: String,
                    index: Bool? = nil,
                    store: Bool? = nil,
                    boost: Float? = nil,
                    coerce: Bool? = nil) {
            
            self.format = format
            self.coerce = coerce
            self.boost = boost
            self.index = index
            self.store = store
        }
    }
}
