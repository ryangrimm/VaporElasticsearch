/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapByte: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.byte

    let type = typeKey.rawValue
    
    public var coerce: Bool?
    public var boost: Float?
    public var docValues: Bool?
    public var ignoreMalformed: Bool?
    public var index: Bool?
    public var nullValue: Int8?
    public var store: Bool?
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
    }
    
    public init(docValues: Bool? = nil,
                index: Bool? = nil,
                store: Bool? = nil,
                boost: Float? = nil,
                coerce: Bool? = nil,
                ignoreMalformed: Bool? = nil,
                nullValue: Int8? = nil) {
        
        self.coerce = coerce
        self.boost = boost
        self.docValues = docValues
        self.ignoreMalformed = ignoreMalformed
        self.index = index
        self.nullValue = nullValue
        self.store = store
    }
}
