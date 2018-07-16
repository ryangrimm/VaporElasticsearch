/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public struct MapObject: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.object

    var properties: [String: AnyMap]?
    var dynamic: Bool? = false
    var enabled: Bool? = true
    
    enum CodingKeys: String, CodingKey {
        case properties
        case dynamic
        case enabled
    }
}
