/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

import Foundation

public class ESTypeKeyword: ElasticsearchType {
    let type = "keyword"
    
    var boost: Float = 1.0
    var eagerGlobalOrdinals: Bool = false
    var fields: [ESTextField]?
    var index: Bool = true
    var indexOptions: ESTypeIndexOptions = .positions
    var norms: Bool = true
    var store: Bool = false
    var similarity: ESTypeSimilarity = .bm25
    
    var docValues: Bool = true
    var ignoreAbove: Int = 2147483647
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
        
        boost = try container.decode(Float.self, forKey: .boost)
        eagerGlobalOrdinals = try container.decode(Bool.self, forKey: .eagerGlobalOrdinals)
        fields = try container.decodeIfPresent([ESTextField].self, forKey: .fields)
        index = try container.decode(Bool.self, forKey: .index)
        indexOptions = try container.decode(ESTypeIndexOptions.self, forKey: .indexOptions)
        norms = try container.decode(Bool.self, forKey: .norms)
        store = try container.decode(Bool.self, forKey: .store)
        similarity = try container.decode(ESTypeSimilarity.self, forKey: .similarity)
        docValues = try container.decode(Bool.self, forKey: .docValues)
        ignoreAbove = try container.decode(Int.self, forKey: .ignoreAbove)
        nullValue = try container.decodeIfPresent(String.self, forKey: .nullValue)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(boost, forKey: .boost)
        try container.encode(eagerGlobalOrdinals, forKey: .eagerGlobalOrdinals)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encode(index, forKey: .index)
        try container.encode(indexOptions, forKey: .indexOptions)
        try container.encode(norms, forKey: .norms)
        try container.encode(store, forKey: .store)
        try container.encode(similarity, forKey: .similarity)
        try container.encode(docValues, forKey: .docValues)
        try container.encode(ignoreAbove, forKey: .ignoreAbove)
        try container.encodeIfPresent(nullValue, forKey: .nullValue)
    }
    
    override init() {
        super.init()
    }
}
