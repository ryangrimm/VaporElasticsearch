/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapJoin: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.join
    
    /// Holds the string that Elasticsearch uses to identify the mapping type
    public let type = typeKey.rawValue
    public let relations: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case type
        case relations
    }
    
    public init(relations: [String: String]) {
        self.relations = relations
    }
}
