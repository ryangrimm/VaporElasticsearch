

public protocol Mappable: Codable {
    var type: MapType { get }
    init()
    
    var overrideType: MapType? { get set }
}

extension Mappable {
    public var overrideType: MapType? {
        get {
            return nil
        }
        set { }
    }
}

/// :nodoc:
internal struct AnyMappable : Codable {
    var base: Mappable
    
    init(_ base: Mappable) {
        self.base = base
    }
    
    private enum CodingKeys : CodingKey {
        case type
        case base
        case properties
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decodeIfPresent(MapType.self, forKey: .type)
        if let type = type {
            self.base = try type.metatype.init(from: decoder)
            // Due to the Swift Float type being used for a few of the ES types,
            // we need to do a bit of extra work here to corretly differentiate
            // which one we're using as a backing type.
            if self.base is ModelFloat.Mapping {
                switch type {
                case MapType.halfFloat:
                    self.base.overrideType = MapType.halfFloat
                case MapType.scaledFloat:
                    self.base.overrideType = MapType.scaledFloat
                default:
                    break
                }
            }
            // We're currently using the MapObject to represent both ES objects and ES nested objects
            else if type == MapType.nested {
                self.base.overrideType = MapType.nested
            }
        }
        else {
            if container.contains(.properties) {
                self.base = try MapObject(from: decoder)
            }
            else {
                throw ElasticsearchError(identifier: "index_decode_failed", reason: "Unable to decode index structure", source: .capture())
            }
        }
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let overrideType = base.overrideType {
            try container.encode(overrideType, forKey: .type)
        } else {
            try container.encode(base.type, forKey: .type)
        }
        try base.encode(to: encoder)
    }
}

