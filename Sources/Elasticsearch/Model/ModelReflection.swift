
import Foundation

public protocol ModelReflection: AnyReflectable {
    static var allowDynamicKeys: Bool { get }
    static var enableSearching: Bool { get }
    
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
    
    
    public static var allowDynamicKeys: Bool {
        return false
    }
    
    public static var enableSearching: Bool {
        return true
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
            
            switch property.type {
            case is ModelBinary?.Type, is ModelBinary.Type, is [ModelBinary].Type, is [ModelBinary]?.Type:
                esTypes[key] = ModelBinary.Mapping()
            case is ModelBool?.Type, is ModelBool.Type, is [ModelBool].Type, is [ModelBool]?.Type:
                esTypes[key] = ModelBool.Mapping()
            case is ModelByte?.Type, is ModelByte.Type, is [ModelByte].Type, is [ModelByte]?.Type:
                esTypes[key] = ModelByte.Mapping()
            case is ModelCompletionSuggester?.Type, is ModelCompletionSuggester.Type, is [ModelCompletionSuggester].Type, is [ModelCompletionSuggester]?.Type:
                esTypes[key] = ModelCompletionSuggester.Mapping()
            case is ModelDate?.Type, is ModelDate.Type, is [ModelDate].Type, is [ModelDate]?.Type:
                esTypes[key] = ModelDate.Mapping()
            case is ModelDateRange?.Type, is ModelDateRange.Type, is [ModelDateRange].Type, is [ModelDateRange]?.Type:
                esTypes[key] = ModelDateRange.Mapping()
            case is ModelDouble?.Type, is ModelDouble.Type, is [ModelDouble].Type, is [ModelDouble]?.Type:
                esTypes[key] = ModelDouble.Mapping()
            case is ModelDoubleRange?.Type, is ModelDoubleRange.Type, is [ModelDoubleRange].Type, is [ModelDoubleRange]?.Type:
                esTypes[key] = ModelDoubleRange.Mapping()
            case is ModelFloat?.Type, is ModelFloat.Type, is [ModelFloat].Type, is [ModelFloat]?.Type:
                esTypes[key] = ModelFloat.Mapping()
            case is ModelFloatRange?.Type, is ModelFloatRange.Type, is [ModelFloatRange].Type, is [ModelFloatRange]?.Type:
                esTypes[key] = ModelFloatRange.Mapping()
            case is ModelGeoPoint?.Type, is ModelGeoPoint.Type, is [ModelGeoPoint].Type, is [ModelGeoPoint]?.Type:
                esTypes[key] = ModelGeoPoint.Mapping()
            case is ModelGeoShape?.Type, is ModelGeoShape.Type, is [ModelGeoShape].Type, is [ModelGeoShape]?.Type:
                esTypes[key] = ModelGeoShape.Mapping()
            case is ModelIPAddress?.Type, is ModelIPAddress.Type, is [ModelIPAddress].Type, is [ModelIPAddress]?.Type:
                esTypes[key] = ModelIPAddress.Mapping()
            case is ModelInteger?.Type, is ModelInteger.Type, is [ModelInteger].Type, is [ModelInteger]?.Type:
                esTypes[key] = ModelInteger.Mapping()
            case is ModelIntegerRange?.Type, is ModelIntegerRange.Type, is [ModelIntegerRange].Type, is [ModelIntegerRange]?.Type:
                esTypes[key] = ModelIntegerRange.Mapping()
            case is ModelJoin?.Type, is ModelJoin.Type, is [ModelJoin].Type, is [ModelJoin]?.Type:
                esTypes[key] = ModelJoin.Mapping()
            case is ModelKeyword?.Type, is ModelKeyword.Type, is [ModelKeyword].Type, is [ModelKeyword]?.Type:
                esTypes[key] = ModelKeyword.Mapping()
            case is ModelLong?.Type, is ModelLong.Type, is [ModelLong].Type, is [ModelLong]?.Type:
                esTypes[key] = ModelLong.Mapping()
            case is ModelLongRange?.Type, is ModelLongRange.Type, is [ModelLongRange].Type, is [ModelLongRange]?.Type:
                esTypes[key] = ModelLongRange.Mapping()
            case is ModelPercolator?.Type, is ModelPercolator.Type, is [ModelPercolator].Type, is [ModelPercolator]?.Type:
                esTypes[key] = ModelPercolator.Mapping()
            case is ModelShort?.Type, is ModelShort.Type, is [ModelShort].Type, is [ModelShort]?.Type:
                esTypes[key] = ModelShort.Mapping()
            case is ModelText?.Type, is ModelText.Type, is [ModelText].Type, is [ModelText]?.Type:
                esTypes[key] = ModelText.Mapping()
            case is ModelTokenCount?.Type, is ModelTokenCount.Type, is [ModelTokenCount].Type, is [ModelTokenCount]?.Type:
                esTypes[key] = ModelTokenCount.Mapping()
            default:
                let propertyTypeString = String(describing: property.type)
                
                for inner in Self.innerModelTypes {
                    let innerTypeString = String(describing: inner)
                    let types = [
                        innerTypeString,
                        "Optional<\(innerTypeString)>",
                        "Array<\(innerTypeString)>",
                        "Optional<Array<\(innerTypeString)>>"
                    ]
                    if types.contains(propertyTypeString) {
                        let innerTypes = try inner.generateIndexJSON()
                        esTypes[key] = MapObject(properties: innerTypes, dynamic: inner.allowDynamicKeys, enabled: inner.enableSearching)
                        break
                    }
                }
                
                if let arrayType = property.type as? [Any].Type {
                    print(arrayType.Element.self)
                }
                print("Skipping: \(property.path): \(property.type)")
                break
            }
        }
        return esTypes
    }
}
