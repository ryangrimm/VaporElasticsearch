/// :nodoc:
public enum MapType: String, Codable {
    case text
    case keyword
    case long
    case integer
    case short
    case byte
    case double
    case float
    case halfFloat = "half_float"
    case scaledFloat = "scaled_float"
    case date
    case boolean
    case binary
    case integerRange = "integer_range"
    case floatRange = "float_range"
    case longRange = "long_range"
    case doubleRange = "double_range"
    case dateRange = "date_range"
    case object
    case nested
    case geoPoint = "geo_point"
    case geoShape
    case ipAddress = "ip"
    case completionSuggester = "completion"
    case tokenCount = "token_count"
    case percolator
    case join
    
    var metatype: Mappable.Type {
        switch self {
        case .text:
            return MapText.self
        case .keyword:
            return MapKeyword.self
        case .long:
            return MapLong.self
        case .integer:
            return MapInteger.self
        case .short:
            return MapShort.self
        case .byte:
            return MapByte.self
        case .double:
            return MapDouble.self
        case .float:
            return MapFloat.self
        case .halfFloat:
            return MapHalfFloat.self
        case .scaledFloat:
            return MapScaledFloat.self
        case .date:
            return MapDate.self
        case .boolean:
            return MapBoolean.self
        case .binary:
            return MapBinary.self
        case .integerRange:
            return MapIntegerRange.self
        case .floatRange:
            return MapFloatRange.self
        case .longRange:
            return MapLongRange.self
        case .doubleRange:
            return MapDoubleRange.self
        case .dateRange:
            return MapDateRange.self
        case .object:
            return MapObject.self
        case .nested:
            return MapNested.self
        case .geoPoint:
            return MapGeoPoint.self
        case .geoShape:
            return MapGeoShape.self
        case .ipAddress:
            return MapIPAddress.self
        case .completionSuggester:
            return MapCompletionSuggester.self
        case .tokenCount:
            return MapTokenCount.self
        case .percolator:
            return MapPercolator.self
        case .join:
            return MapJoin.self
        }
    }
}

/// :nodoc:
internal struct AnyMap : Codable {
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
        
        try container.encode(type(of: base).typeKey, forKey: .type)
        try base.encode(to: encoder)
    }
}

