/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public class ESTypeFloat: ElasticsearchType {
    let type = "float"
    
    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: Float? = nil
    var store: Bool = false
    
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
        
        coerce = try container.decode(Bool.self, forKey: .coerce)
        boost = try container.decode(Float.self, forKey: .boost)
        docValues = try container.decode(Bool.self, forKey: .docValues)
        ignoreMalformed = try container.decode(Bool.self, forKey: .ignoreMalformed)
        index = try container.decode(Bool.self, forKey: .index)
        nullValue = try container.decodeIfPresent(Float.self, forKey: .nullValue)
        store = try container.decode(Bool.self, forKey: .store)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(coerce, forKey: .coerce)
        try container.encode(boost, forKey: .boost)
        try container.encode(docValues, forKey: .docValues)
        try container.encode(ignoreMalformed, forKey: .ignoreMalformed)
        try container.encode(index, forKey: .index)
        try container.encodeIfPresent(nullValue, forKey: .nullValue)
        try container.encode(store, forKey: .store)
    }
    
    override init() {
        super.init()
    }
}
