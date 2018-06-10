/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

import Foundation

public class ESTypeKeyword: ESType {
    let type = "keyword"
    
    var boost: Float? = 1.0
    var eagerGlobalOrdinals: Bool? = false
    var fields: [ESTextField]?
    var index: Bool? = true
    var indexOptions: ESTypeIndexOptions? = .positions
    var norms: Bool? = true
    var store: Bool? = false
    var similarity: ESTypeSimilarity? = .bm25
    
    var docValues: Bool? = true
    var ignoreAbove: Int? = 2147483647
    var nullValue: String?
    // var normalizer
    
    enum CodingKeys: String, CodingKey {
        case type
        case boost
        case eagerGlobalOrdinals = "eager_global_ordinals"
        case fields
        case index
        case indexOptions = "index_options"
        case norms
        case store
        case similarity
        case docValues = "doc_values"
        case ignoreAbove = "ignore_above"
        case nullValue = "null_value"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        super.init()
        
        boost = try container.decodeIfPresent(Float.self, forKey: .boost)
        eagerGlobalOrdinals = try container.decodeIfPresent(Bool.self, forKey: .eagerGlobalOrdinals)
        fields = try container.decodeIfPresent([ESTextField].self, forKey: .fields)
        index = try container.decodeIfPresent(Bool.self, forKey: .index)
        indexOptions = try container.decodeIfPresent(ESTypeIndexOptions.self, forKey: .indexOptions)
        norms = try container.decodeIfPresent(Bool.self, forKey: .norms)
        store = try container.decodeIfPresent(Bool.self, forKey: .store)
        similarity = try container.decodeIfPresent(ESTypeSimilarity.self, forKey: .similarity)
        docValues = try container.decodeIfPresent(Bool.self, forKey: .docValues)
        ignoreAbove = try container.decodeIfPresent(Int.self, forKey: .ignoreAbove)
        nullValue = try container.decodeIfPresent(String.self, forKey: .nullValue)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(boost, forKey: .boost)
        try container.encodeIfPresent(eagerGlobalOrdinals, forKey: .eagerGlobalOrdinals)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(index, forKey: .index)
        try container.encodeIfPresent(indexOptions, forKey: .indexOptions)
        try container.encodeIfPresent(norms, forKey: .norms)
        try container.encodeIfPresent(store, forKey: .store)
        try container.encodeIfPresent(similarity, forKey: .similarity)
        try container.encodeIfPresent(docValues, forKey: .docValues)
        try container.encodeIfPresent(ignoreAbove, forKey: .ignoreAbove)
        try container.encodeIfPresent(nullValue, forKey: .nullValue)
    }
    
    override init() {
        super.init()
    }
}
