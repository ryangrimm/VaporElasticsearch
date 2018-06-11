enum ESTypeMap : String, Codable {
    
    // be careful not to rename these – the encoding/decoding relies on the string
    // values of the cases. If you want the decoding to be reliant on case
    // position rather than name, then you can change to enum TagType : Int.
    // (the advantage of the String rawValue is that the JSON is more readable)
    case text
    case keyword
    case long
    case integer
    case short
    case byte
    case double
    case float
    case halfFloat
    case scaledFloat
    case date
    case boolean
    case binary
    case integerRange
    case floatRange
    case longRange
    case doubleRange
    case dateRange
    case object
    case nested
    case geoPoint
    case geoShape
    case ipAddress
    
    var metatype: ESType.Type {
        switch self {
        case .text:
            return ESTypeText.self
        case .keyword:
            return ESTypeKeyword.self
        case .long:
            return ESTypeLong.self
        case .integer:
            return ESTypeInteger.self
        case .short:
            return ESTypeShort.self
        case .byte:
            return ESTypeByte.self
        case .double:
            return ESTypeDouble.self
        case .float:
            return ESTypeFloat.self
        case .halfFloat:
            return ESTypeHalfFloat.self
        case .scaledFloat:
            return ESTypeScaledFloat.self
        case .date:
            return ESTypeDate.self
        case .boolean:
            return ESTypeBolean.self
        case .binary:
            return ESTypeBinary.self
        case .integerRange:
            return ESTypeIntegerRange.self
        case .floatRange:
            return ESTypeFloatRange.self
        case .longRange:
            return ESTypeLongRange.self
        case .doubleRange:
            return ESTypeDoubleRange.self
        case .dateRange:
            return ESTypeDateRange.self
        case .object:
            return ESTypeObject.self
        case .nested:
            return ESTypeNested.self
        case .geoPoint:
            return ESTypeGeoPoint.self
        case .geoShape:
            return ESTypeGeoShape.self
        case .ipAddress:
            return ESTypeIPAddress.self
        }
    }
}

struct AnyESType : Codable {
    var base: ESType
    
    init(_ base: ESType) {
        self.base = base
    }
    
    private enum CodingKeys : CodingKey {
        case type
        case base
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(ESTypeMap.self, forKey: .type)
        self.base = try type.metatype.init(from: decoder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type(of: base).typeKey, forKey: .type)
        try base.encode(to: encoder)
    }
}

