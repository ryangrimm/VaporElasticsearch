/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct ESTypeDateRange: ESType {
    static var typeKey = ESTypeMap.dateRange
    
    let type = "date_range"
    
    var format: String
    var coerce: Bool? = true
    var boost: Float? = 1.0
    var index: Bool? = true
    var store: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case format
        case coerce
        case boost
        case index
        case store
    }
}
