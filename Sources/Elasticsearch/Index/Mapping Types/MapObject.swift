/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public struct MapObject: Mappable, DefinesNormalizers, DefinesAnalyzers {
    /// :nodoc:
    public static var typeKey = MapType.object

    public let properties: [String: Mappable]?
    public let dynamic: Bool?
    public let enabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case properties
        case dynamic
        case enabled
    }
    
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
