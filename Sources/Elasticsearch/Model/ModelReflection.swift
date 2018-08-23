
import Foundation

public protocol ModelReflection: AnyReflectable {
    static var innerModelTypes: [ModelBaseObject.Type] { get }
    static func tuneConfiguration(key: String, config: inout Mappable)
    
    static func generateIndexJSON() throws -> [String: Mappable]
}

extension ModelReflection {
    public static var innerModelTypes: [ModelBaseObject.Type] {
        return [ModelBaseObject.Type]()
    }
    
    public static func tuneConfiguration(key: String, config: inout Mappable) {
    }
    
    public static func generateIndexJSON() throws -> [String: Mappable] {
        var esTypes = [String: Mappable]()
        
        for property in try self.reflectProperties(depth: 0) {
            let key: String
            if let lastKey = property.path.last {
                key = lastKey
            } else {
                continue
            }
            
            var esType: Mappable? = nil
            
            switch property.type {
            case is ModelBinary?.Type, is ModelBinary.Type, is [ModelBinary].Type, is [ModelBinary]?.Type:
                esType = ModelBinary.Mapping()
            case is ModelBool?.Type, is ModelBool.Type, is [ModelBool].Type, is [ModelBool]?.Type:
                esType = ModelBool.Mapping()
            case is ModelByte?.Type, is ModelByte.Type, is [ModelByte].Type, is [ModelByte]?.Type:
                esType = ModelByte.Mapping()
            case is ModelCompletionSuggester?.Type, is ModelCompletionSuggester.Type, is [ModelCompletionSuggester].Type, is [ModelCompletionSuggester]?.Type:
                esType = ModelCompletionSuggester.Mapping()
            case is ModelDate?.Type, is ModelDate.Type, is [ModelDate].Type, is [ModelDate]?.Type:
                esType = ModelDate.Mapping()
            case is ModelDateRange?.Type, is ModelDateRange.Type, is [ModelDateRange].Type, is [ModelDateRange]?.Type:
                esType = ModelDateRange.Mapping()
            case is ModelDouble?.Type, is ModelDouble.Type, is [ModelDouble].Type, is [ModelDouble]?.Type:
                esType = ModelDouble.Mapping()
            case is ModelDoubleRange?.Type, is ModelDoubleRange.Type, is [ModelDoubleRange].Type, is [ModelDoubleRange]?.Type:
                esType = ModelDoubleRange.Mapping()
            case is ModelFloat?.Type, is ModelFloat.Type, is [ModelFloat].Type, is [ModelFloat]?.Type:
                esType = ModelFloat.Mapping()
            case is ModelFloatRange?.Type, is ModelFloatRange.Type, is [ModelFloatRange].Type, is [ModelFloatRange]?.Type:
                esType = ModelFloatRange.Mapping()
            case is ModelGeoPoint?.Type, is ModelGeoPoint.Type, is [ModelGeoPoint].Type, is [ModelGeoPoint]?.Type:
                esType = ModelGeoPoint.Mapping()
            case is ModelGeoShape?.Type, is ModelGeoShape.Type, is [ModelGeoShape].Type, is [ModelGeoShape]?.Type:
                esType = ModelGeoShape.Mapping()
            case is ModelIPAddress?.Type, is ModelIPAddress.Type, is [ModelIPAddress].Type, is [ModelIPAddress]?.Type:
                esType = ModelIPAddress.Mapping()
            case is ModelInteger?.Type, is ModelInteger.Type, is [ModelInteger].Type, is [ModelInteger]?.Type:
                esType = ModelInteger.Mapping()
            case is ModelIntegerRange?.Type, is ModelIntegerRange.Type, is [ModelIntegerRange].Type, is [ModelIntegerRange]?.Type:
                esType = ModelIntegerRange.Mapping()
            case is ModelJoin?.Type, is ModelJoin.Type, is [ModelJoin].Type, is [ModelJoin]?.Type:
                esType = ModelJoin.Mapping()
            case is ModelKeyword?.Type, is ModelKeyword.Type, is [ModelKeyword].Type, is [ModelKeyword]?.Type:
                esType = ModelKeyword.Mapping()
            case is ModelLong?.Type, is ModelLong.Type, is [ModelLong].Type, is [ModelLong]?.Type:
                esType = ModelLong.Mapping()
            case is ModelLongRange?.Type, is ModelLongRange.Type, is [ModelLongRange].Type, is [ModelLongRange]?.Type:
                esType = ModelLongRange.Mapping()
            case is ModelPercolator?.Type, is ModelPercolator.Type, is [ModelPercolator].Type, is [ModelPercolator]?.Type:
                esType = ModelPercolator.Mapping()
            case is ModelShort?.Type, is ModelShort.Type, is [ModelShort].Type, is [ModelShort]?.Type:
                esType = ModelShort.Mapping()
            case is ModelText?.Type, is ModelText.Type, is [ModelText].Type, is [ModelText]?.Type:
                esType = ModelText.Mapping()
            case is ModelTokenCount?.Type, is ModelTokenCount.Type, is [ModelTokenCount].Type, is [ModelTokenCount]?.Type:
                esType = ModelTokenCount.Mapping()
            default:
                break
            }
            
            if var type = esType {
                self.tuneConfiguration(key: key, config: &type)
                esTypes[key] = type
            }
            // Check to see if it's an inner (object/nested) property
            else {
                let propertyTypeString = String(describing: property.type)
                
                for inner in Self.innerModelTypes {
                    let innerTypeString = String(describing: inner)
                    let types = [
                        innerTypeString,
                        "Optional<\(innerTypeString)>",
                    ]
                    let arrayTypes = [
                        "Array<\(innerTypeString)>",
                        "Optional<Array<\(innerTypeString)>>"
                    ]
                    if types.contains(propertyTypeString) || arrayTypes.contains(propertyTypeString) {
                        let innerTypes = try inner.generateIndexJSON()
                        var type = MapObject(properties: innerTypes)
                        type.allowTypeOverride = arrayTypes.contains(propertyTypeString)
                        esType = type
                        self.tuneConfiguration(key: key, config: &esType!)
                        esTypes[key] = esType

                        break
                    }
                }
            }
        }

        return esTypes
    }
}
