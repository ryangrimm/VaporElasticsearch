/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public class ESTypeText: ESType {
    let type = "text"
    
    var boost: Float = 1.0
    var eagerGlobalOrdinals: Bool = false
    var fields: [ESTextField]?
    var index: Bool = true
    var indexOptions: ESTypeIndexOptions = .positions
    var norms: Bool = true
    var store: Bool = false
    var similarity: ESTypeSimilarity = .bm25
    
    var analyzer: String?
    var searchAnalyzer: String?
    var searchQuoteAnalyzer: String?
    var fielddata: Bool = false
    var termVector: ESTypeTermVector = .no
    
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
        analyzer = try container.decodeIfPresent(String.self, forKey: .analyzer)
        searchAnalyzer = try container.decodeIfPresent(String.self, forKey: .searchAnalyzer)
        searchQuoteAnalyzer = try container.decodeIfPresent(String.self, forKey: .searchQuoteAnalyzer)
        fielddata = try container.decode(Bool.self, forKey: .fielddata)
        termVector = try container.decode(ESTypeTermVector.self, forKey: .termVector)
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
        try container.encodeIfPresent(analyzer, forKey: .analyzer)
        try container.encodeIfPresent(searchAnalyzer, forKey: .searchAnalyzer)
        try container.encodeIfPresent(searchQuoteAnalyzer, forKey: .searchQuoteAnalyzer)
        try container.encode(fielddata, forKey: .fielddata)
        try container.encode(termVector, forKey: .termVector)
    }
    
    override init() {
        super.init()
    }
}
