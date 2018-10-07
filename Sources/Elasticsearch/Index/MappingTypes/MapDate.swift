/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapDate: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.date

    /// Holds the string that Elasticsearch uses to identify the mapping type
    public let type = typeKey.rawValue
    public let boost: Float?
    public let docValues: Bool?
    public let format: String?
    public let locale: String?
    public let ignoreMalformed: Bool?
    public let index: Bool?
    public let nullValue: Bool?
    public let store: Bool?
    
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
    
    public init(format: String? = nil,
                docValues: Bool? = nil,
                index: Bool? = nil,
                store: Bool? = nil,
                boost: Float? = nil,
                locale: String? = nil,
                ignoreMalformed: Bool? = nil,
                nullValue: Bool? = nil) {
        
        self.boost = boost
        self.docValues = docValues
        self.format = format
        self.locale = locale
        self.ignoreMalformed = ignoreMalformed
        self.index = index
        self.nullValue = nullValue
        self.store = store
    }
}
