/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct ESTypeIPAddress: ESType {
    static var typeKey = ESTypeMap.ipAddress

    let type = "ip"
    
    var boost: Float? = 1.0
    var docValues: Bool? = true
    var index: Bool? = true
    var nullValue: Bool? = nil
    var store: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case boost
        case docValues = "doc_values"
        case index
        case nullValue = "null_value"
        case store
    }
}
