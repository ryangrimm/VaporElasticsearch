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
            return ModelText.Mapping.self
        case .keyword:
            return ModelKeyword.Mapping.self
        case .long:
            return ModelLong.Mapping.self
        case .integer:
            return ModelInteger.Mapping.self
        case .short:
            return ModelShort.Mapping.self
        case .byte:
            return ModelByte.Mapping.self
        case .double:
            return ModelDouble.Mapping.self
        case .float:
            return ModelFloat.Mapping.self
        case .halfFloat:
            return ModelFloat.Mapping.self
        case .scaledFloat:
            return ModelFloat.Mapping.self
        case .date:
            return ModelDate.Mapping.self
        case .boolean:
            return ModelBool.Mapping.self
        case .binary:
            return ModelBinary.Mapping.self
        case .integerRange:
            return ModelIntegerRange.Mapping.self
        case .floatRange:
            return ModelFloatRange.Mapping.self
        case .longRange:
            return ModelLongRange.Mapping.self
        case .doubleRange:
            return ModelDoubleRange.Mapping.self
        case .dateRange:
            return ModelDateRange.Mapping.self
        case .object:
            return MapObject.self
        case .nested:
            return MapNested.self
        case .geoPoint:
            return ModelGeoPoint.Mapping.self
        case .geoShape:
            return ModelGeoShape.Mapping.self
        case .ipAddress:
            return ModelIPAddress.Mapping.self
        case .completionSuggester:
            return ModelCompletionSuggester.Mapping.self
        case .tokenCount:
            return ModelTokenCount.Mapping.self
        case .percolator:
            return ModelPercolator.Mapping.self
        case .join:
            return ModelJoin.Mapping.self
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
            // Due to the Swift Float type being used for a few of the ES types,
            // we need to do a bit of extra work here to corretly differentiate
            // which one we're using as a backing type.
            if var float = self.base as? ModelFloat.Mapping {
                switch type {
                case MapType.halfFloat:
                    float.type = MapType.halfFloat
                case MapType.scaledFloat:
                    float.type = MapType.scaledFloat
                default:
                    break
                }
                self.base = float
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
        
        try container.encode(base.type, forKey: .type)
        try base.encode(to: encoder)
    }
}

