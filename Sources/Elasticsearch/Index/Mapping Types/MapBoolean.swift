/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapBoolean: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.boolean
    
    public let type = typeKey.rawValue
    public let boost: Float?
    public let docValues: Bool?
    public let index: Bool?
    public let nullValue: Bool?
    public let store: Bool?
    
    enum CodingKeys: String, CodingKey {
        case type
        case boost
        case docValues = "doc_values"
        case index
        case nullValue = "null_value"
        case store
    }
    
    public init(docValues: Bool? = nil,
                index: Bool? = nil,
                store: Bool? = nil,
                boost: Float? = nil,
                nullValue: Bool? = nil) {
        
        self.boost = boost
        self.docValues = docValues
        self.index = index
        self.nullValue = nullValue
        self.store = store
    }
}
