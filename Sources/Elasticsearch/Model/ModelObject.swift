import HTTP
import Crypto

public protocol ModelObject: ModelType {
    static func tuneConfiguration(key: String, config: inout Mappable)
}

extension ModelObject {
    public static var backingType: Mappable.Type {
        return MapObject.self
    }
    
    public static func tuneConfiguration(key: String, config: inout Mappable) {
    }
    
    internal func generateProperty() throws -> MapObject {
        var properties: [String: Mappable]? = [String: Mappable]()
        
        let mirror = Mirror(reflecting: self)
        for case let (keyName?, value) in mirror.children {
            var esType: Mappable? = nil
            switch type(of: value) {
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
                /*
            case is ModelObject?.Type, is ModelObject.Type, is [ModelObject.Type], is [ModelObject]?.Type:
                esType = value as
 */
            default:
                break
            }
            
            if var esType = esType {
                type(of: self).tuneConfiguration(key: keyName, config: &esType)
                properties![keyName] = esType
            }
        }
        
        if properties!.count == 0 {
            properties = nil
        }
        
        return MapObject(properties: properties, dynamic: false, enabled: true)
    }
}

public struct MapObject: Mappable, DefinesNormalizers, DefinesAnalyzers {
    public let type = MapType.object
    public var properties: [String: Mappable]?
    public var dynamic: Bool?
    public var enabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case properties
        case dynamic
        case enabled
    }
    
    public init() { }
    
    public init(dynamic: Bool? = false, enabled: Bool? = true, properties: (inout ChainableNestedProperties) -> Void) {
        self.dynamic = dynamic
        self.enabled = enabled
        var chain = ChainableNestedProperties()
        properties(&chain)
        self.properties = chain.properties()
    }
    
    public init(properties: [String: Mappable]?, dynamic: Bool? = false, enabled: Bool? = true) {
        self.properties = properties
        self.dynamic = dynamic
        self.enabled = enabled
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let properties = properties {
            try container.encodeIfPresent(properties.mapValues { AnyMap($0) }, forKey: .properties)
        }
        try container.encodeIfPresent(dynamic, forKey: .dynamic)
        try container.encodeIfPresent(enabled, forKey: .enabled)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.properties) {
            self.properties = try container.decode([String: AnyMap].self, forKey: CodingKeys.properties).mapValues { $0.base }
        } else {
            self.properties = nil
        }
        if container.contains(.enabled) {
            do {
                self.enabled = (try container.decode(Bool.self, forKey: .enabled))
            }
            catch {
                self.enabled = try container.decode(String.self, forKey: .enabled) == "true"
            }
        }
        else {
            self.enabled = true
        }
        if container.contains(.dynamic) {
            do {
                self.dynamic = (try container.decode(Bool.self, forKey: .dynamic))
            }
            catch {
                self.dynamic = try container.decode(String.self, forKey: .dynamic) == "true"
            }
        }
        else {
            self.dynamic = false
        }
    }
    
    /// :nodoc:
    public func definedNormalizers() -> [Normalizer] {
        var normalizers = [Normalizer]()
        if let properties = self.properties {
            for (_, property) in properties {
                if property.self is DefinesNormalizers {
                    let property = property as! DefinesNormalizers
                    normalizers += property.definedNormalizers()
                }
            }
        }
        return normalizers
    }
    
    /// :nodoc:
    public func definedAnalyzers() -> [Analyzer] {
        var analyzers = [Analyzer]()
        if let properties = self.properties {
            for (_, property) in properties {
                if property.self is DefinesAnalyzers {
                    let property = property as! DefinesAnalyzers
                    analyzers += property.definedAnalyzers()
                }
            }
        }
        return analyzers
    }
}
