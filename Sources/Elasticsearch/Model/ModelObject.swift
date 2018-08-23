import HTTP
import Crypto

public typealias ModelObject = ModelBaseObject & Reflectable

public protocol ModelBaseObject: ModelType, ModelReflection {
    static func tuneConfiguration(key: String, config: inout Mappable)
}

extension ModelBaseObject {
    public static var backingType: Mappable.Type {
        return MapObject.self
    }
    
    public static func tuneConfiguration(key: String, config: inout Mappable) {
    }
}

public struct MapObject: Mappable, DefinesNormalizers, DefinesAnalyzers {
    public let type: MapType
    public var overrideType: MapType? {
        didSet {
            if allowTypeOverride == false {
                overrideType = nil
                return
            }
            if overrideType != MapType.object && overrideType != MapType.nested {
                overrideType = oldValue
            }
        }
    }
    
    public var properties: [String: Mappable]?
    public var dynamic: Bool?
    public var enabled: Bool?
    var allowTypeOverride: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        case dynamic
        case enabled
    }
    
    public init() {
        self.type = MapType.object
    }
    
    public init(dynamic: Bool? = false, enabled: Bool? = true, properties: (inout ChainableNestedProperties) -> Void) {
        self.type = MapType.object
        self.dynamic = dynamic
        self.enabled = enabled
        var chain = ChainableNestedProperties()
        properties(&chain)
        self.properties = chain.properties()
    }
    
    public init(properties: [String: Mappable]?, dynamic: Bool? = false, enabled: Bool? = true) {
        self.type = MapType.object
        self.properties = properties
        self.dynamic = dynamic
        self.enabled = enabled
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if self.type == MapType.nested {
            try container.encode(self.type, forKey: .type)
        }
        if let properties = properties {
            try container.encodeIfPresent(properties.mapValues { AnyMappable($0) }, forKey: .properties)
        }
        try container.encodeIfPresent(dynamic, forKey: .dynamic)
        if self.type == MapType.object {
            try container.encodeIfPresent(enabled, forKey: .enabled)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.type) {
            self.type = try container.decode(MapType.self, forKey: .type)
        }
        else {
            self.type = MapType.object
        }
        
        if container.contains(.properties) {
            self.properties = try container.decode([String: AnyMappable].self, forKey: CodingKeys.properties).mapValues { $0.base }
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
