/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public class ESTypeBinary: ESType {
    let type = "binary"
    
    var docValues: Bool? = true
    var store: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case docValues = "doc_values"
        case store
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        super.init()
        
        docValues = try container.decodeIfPresent(Bool.self, forKey: .docValues)
        store = try container.decodeIfPresent(Bool.self, forKey: .store)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(docValues, forKey: .docValues)
        try container.encodeIfPresent(store, forKey: .store)
    }
    
    override init() {
        super.init()
    }
}
