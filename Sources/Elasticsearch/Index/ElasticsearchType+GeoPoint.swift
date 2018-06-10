/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public class ESTypeGeoPoint: ESType {
    let type = "geo_point"

    var ignoreMalformed: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case ignoreMalformed = "ignore_malformed"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        super.init()
        
        ignoreMalformed = try container.decodeIfPresent(Bool.self, forKey: .ignoreMalformed)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(ignoreMalformed, forKey: .ignoreMalformed)
    }
    
    override init() {
        super.init()
    }
}
