/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

import Foundation

public struct MapKeyword: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.keyword

    let type = typeKey.rawValue
    
    public var boost: Float? = 1.0
    public var eagerGlobalOrdinals: Bool? = false
    public var fields: [String: TextField]?
    public var index: Bool? = true
    public var indexOptions: TextIndexOptions?
    public var norms: Bool? = true
    public var store: Bool? = false
    public var similarity: SimilarityType? = .bm25
    public var docValues: Bool? = true
    public var ignoreAbove: Int? = 2147483647
    public var nullValue: String?
    public var normalizer: String?
    
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
        case normalizer
    }

    public init(docValues: Bool? = true,
                index: Bool? = true,
                store: Bool? = false,
                fields: [String: TextField]?,
                boost: Float? = 1.0,
                eagerGlobalOrdinals: Bool? = false,
                indexOptions: TextIndexOptions?,
                norms: Bool? = true,
                similarity: SimilarityType? = .bm25,
                ignoreAbove: Int? = 2147483647,
                nullValue: String? = nil,
                normalizer: String? = nil) {
        
        self.docValues = docValues
        self.index = index
        self.store = store
        self.fields = fields
        self.boost = boost
        self.eagerGlobalOrdinals = eagerGlobalOrdinals
        self.indexOptions = indexOptions
        self.norms = norms
        self.similarity = similarity
        self.ignoreAbove = ignoreAbove
        self.nullValue = nullValue
        self.normalizer = normalizer
    }
}
