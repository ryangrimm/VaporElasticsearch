/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public struct MapNested: Mappable, ModifiesIndex, IndexModifies {
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
    
    public func modifyBeforeSending(index: ElasticsearchIndex) {
        if let properties = self.properties {
            for (_, property) in properties {
                if property.self is ModifiesIndex {
                    let modify = property as! ModifiesIndex
                    modify.modifyBeforeSending(index: index)
                }
            }
        }
    }
    
    public mutating func modifyAfterReceiving(index: ElasticsearchIndex) {
        if let properties = self.properties {
            for (_, property) in properties {
                if property.self is IndexModifies {
                    var modify = property as! IndexModifies
                    modify.modifyAfterReceiving(index: index)
                }
            }
        }
    }
}
