/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public struct MapText: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.text

    let type = typeKey.rawValue
    
    public var boost: Float? = 1.0
    public var eagerGlobalOrdinals: Bool? = false
    public var fields: [String: TextField]?
    public var index: Bool? = true
    public var indexOptions: TextIndexOptions? = .positions
    public var norms: Bool? = true
    public var store: Bool? = false
    public var similarity: SimilarityType? = .bm25
    
    public var analyzer: String?
    public var searchAnalyzer: String?
    public var searchQuoteAnalyzer: String?
    public var fielddata: Bool? = false
    public var termVector: TermVector? = .no
    
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
        case analyzer
        case searchAnalyzer = "search_analyzer"
        case searchQuoteAnalyzer = "search_quote_analyzer"
        case fielddata
        case termVector = "term_vector"
    }

    public init() {}
}
