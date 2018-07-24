/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public struct MapNested: Mappable, DefinesNormalizers, DefinesAnalyzers {
    /// :nodoc:
    public static var typeKey = MapType.nested

    public var properties: [String: AnyMap]?
    public var dynamic: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case properties
        case dynamic
    }
    
    public init(properties: [String: AnyMap]?, dynamic: Bool? = false) {
        self.properties = properties
        self.dynamic = dynamic
    }
    
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
