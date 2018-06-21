/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapFloat: Mappable {
    static var typeKey = MapType.float

    let type = "float"
    
    var coerce: Bool? = true
    var boost: Float? = 1.0
    var docValues: Bool? = true
    var ignoreMalformed: Bool? = false
    var index: Bool? = true
    var nullValue: Float? = nil
    var store: Bool? = false
    
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
