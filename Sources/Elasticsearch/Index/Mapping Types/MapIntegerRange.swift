/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapIntegerRange: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.integerRange

    let type = typeKey.rawValue
    
    public var coerce: Bool? = true
    public var boost: Float? = 1.0
    public var index: Bool? = true
    public var store: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case index
        case store
    }
}
