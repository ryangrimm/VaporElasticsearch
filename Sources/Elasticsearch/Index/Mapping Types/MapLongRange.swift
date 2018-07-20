/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapLongRange: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.longRange
    
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
    
    public init(index: Bool? = true,
                store: Bool? = false,
                boost: Float? = 1.0,
                coerce: Bool? = nil) {
        
        self.index = index
        self.store = store
        self.boost = boost
        self.coerce = coerce
    }
}
