/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapBinary: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.binary

    public let type = typeKey.rawValue
    public let docValues: Bool?
    public let store: Bool?
    
    enum CodingKeys: String, CodingKey {
        case type
        case docValues = "doc_values"
        case store
    }
    
    public init(docValues: Bool? = nil, store: Bool? = nil) {
        self.docValues = docValues
        self.store = store
    }
}
