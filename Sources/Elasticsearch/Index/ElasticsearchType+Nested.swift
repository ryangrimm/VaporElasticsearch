/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public class ESTypeNested: ESType {
    var properties: [String: ESType]?
    var dynamic: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case properties
        case dynamic
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        super.init()
        
        properties = try container.decodeIfPresent([String: ESType]?.self, forKey: .properties) as? [String: ESType]
        dynamic = try container.decodeIfPresent(Bool.self, forKey: .dynamic)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(properties, forKey: .properties)
        try container.encodeIfPresent(dynamic, forKey: .dynamic)
    }
    
    override init() {
        super.init()
    }
}
