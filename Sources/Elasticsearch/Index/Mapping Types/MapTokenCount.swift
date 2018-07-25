/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapTokenCount: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.tokenCount
    
    /// Holds the string that Elasticsearch uses to identify the mapping type
    public let type = typeKey.rawValue
    public let analyzer: String?
    public let enablePositionIncrements: Bool?
    public let boost: Float?
    public let docValues: Bool?
    public let index: Bool?
    public let nullValue: Bool?
    public let store: Bool?
    
    enum CodingKeys: String, CodingKey {
        case type
        case analyzer
        case enablePositionIncrements = "enable_position_increments"
        case boost
        case docValues = "doc_values"
        case index
        case nullValue = "null_value"
        case store
    }
    
    public init(docValues: Bool? = nil,
                index: Bool? = nil,
                store: Bool? = nil,
                analyzer: String? = nil,
                enablePositionIncrements: Bool? = nil,
                boost: Float? = nil,
                nullValue: Bool? = nil) {
        
        self.docValues = docValues
        self.index = index
        self.store = store
        self.analyzer = analyzer
        self.enablePositionIncrements = enablePositionIncrements
        self.boost = boost
        self.nullValue = nullValue
    }
}
