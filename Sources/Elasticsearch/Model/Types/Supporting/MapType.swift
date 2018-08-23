
import Foundation

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
            return MapObject.self
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
