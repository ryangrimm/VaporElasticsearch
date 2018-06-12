/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct ESTypePercolator: ESType {
    static var typeKey = ESTypeMap.percolator
    
    let type = "percolator"
    
    enum CodingKeys: String, CodingKey {
        case type
    }
}
