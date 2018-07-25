/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapFloatRange: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.floatRange

    public let type = typeKey.rawValue
    public let coerce: Bool?
    public let boost: Float?
    public let index: Bool?
    public let store: Bool?
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case index
        case store
    }
    
    public init(index: Bool? = nil,
                store: Bool? = nil,
                boost: Float? = nil,
                coerce: Bool? = nil) {
        
        self.index = index
        self.store = store
        self.boost = boost
        self.coerce = coerce
    }
}
