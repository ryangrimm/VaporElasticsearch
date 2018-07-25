/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapDateRange: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.dateRange
    
    /// Holds the string that Elasticsearch uses to identify the mapping type
    public let type = typeKey.rawValue
    public let format: String
    public let coerce: Bool?
    public let boost: Float?
    public let index: Bool?
    public let store: Bool?
    
    enum CodingKeys: String, CodingKey {
        case type
        case format
        case coerce
        case boost
        case index
        case store
    }
    
    public init(format: String,
                index: Bool? = nil,
                store: Bool? = nil,
                boost: Float? = nil,
                coerce: Bool? = nil) {
        
        self.format = format
        self.coerce = coerce
        self.boost = boost
        self.index = index
        self.store = store
    }
}
