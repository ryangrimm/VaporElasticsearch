/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct ESTypeDate: ESType {
    static var typeKey = ESTypeMap.date

    let type = "date"
    
    var boost: Float? = 1.0
    var docValues: Bool? = true
    var format: String?
    var locale: String?
    var ignoreMalformed: Bool? = false
    var index: Bool? = true
    var nullValue: Bool? = nil
    var store: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case boost
        case docValues = "doc_values"
        case format
        case locale
        case ignoreMalformed = "ignoreMalformed"
        case index
        case nullValue = "null_value"
        case store
    }
}
