/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapShort: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.short

    let type = typeKey.rawValue
    
    public var coerce: Bool? = true
    public var boost: Float? = 1.0
    public var docValues: Bool? = true
    public var ignoreMalformed: Bool? = false
    public var index: Bool? = true
    public var nullValue: Int16? = nil
    public var store: Bool? = false
    
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
}
