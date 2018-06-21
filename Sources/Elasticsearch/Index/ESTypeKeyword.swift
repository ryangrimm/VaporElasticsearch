/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

import Foundation

public struct ESTypeKeyword: ESType {
    static var typeKey = ESTypeMap.keyword

    let type = "keyword"
    
    var boost: Float? = 1.0
    var eagerGlobalOrdinals: Bool? = false
    var fields: [TextField]?
    var index: Bool? = true
    var indexOptions: TextIndexOptions? = .positions
    var norms: Bool? = true
    var store: Bool? = false
    var similarity: SimilarityType? = .bm25
    
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
}
