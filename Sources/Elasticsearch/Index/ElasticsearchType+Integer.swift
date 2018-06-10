/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public class ESTypeInteger: ESType {
    let type = "integer"
    
    var coerce: Bool? = true
    var boost: Float? = 1.0
    var docValues: Bool? = true
    var ignoreMalformed: Bool? = false
    var index: Bool? = true
    var nullValue: Int32? = nil
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        super.init()
        
        coerce = try container.decodeIfPresent(Bool.self, forKey: .coerce)
        boost = try container.decodeIfPresent(Float.self, forKey: .boost)
        docValues = try container.decodeIfPresent(Bool.self, forKey: .docValues)
        ignoreMalformed = try container.decodeIfPresent(Bool.self, forKey: .ignoreMalformed)
        index = try container.decodeIfPresent(Bool.self, forKey: .index)
        nullValue = try container.decodeIfPresent(Int32.self, forKey: .nullValue)
        store = try container.decodeIfPresent(Bool.self, forKey: .store)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(coerce, forKey: .coerce)
        try container.encodeIfPresent(boost, forKey: .boost)
        try container.encodeIfPresent(docValues, forKey: .docValues)
        try container.encodeIfPresent(ignoreMalformed, forKey: .ignoreMalformed)
        try container.encodeIfPresent(index, forKey: .index)
        try container.encodeIfPresent(nullValue, forKey: .nullValue)
        try container.encodeIfPresent(store, forKey: .store)
    }
    
    override init() {
        super.init()
    }
}