/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapBinary: Mappable {
    static var typeKey = MapType.binary

    let type = typeKey.rawValue
    
    var docValues: Bool? = true
    var store: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case docValues = "doc_values"
        case store
    }
}
