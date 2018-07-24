/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public struct MapText: Mappable, DefinesAnalyzers {
    /// :nodoc:
    public static var typeKey = MapType.text

    let type = typeKey.rawValue
    
    public var boost: Float?
    public var eagerGlobalOrdinals: Bool?
    public var fields: [String: TextField]?
    public var index: Bool?
    public var indexOptions: TextIndexOptions?
    public var norms: Bool?
    public var store: Bool?
    public var similarity: SimilarityType?
    
    public var analyzer: Analyzer?
    public var searchAnalyzer: Analyzer?
    public var searchQuoteAnalyzer: Analyzer?
    public var fielddata: Bool?
    public var termVector: TermVector?
    
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

    public init(index: Bool? = nil,
                store: Bool? = nil,
                fields: [String: TextField]? = nil,
                analyzer: Analyzer? = nil,
                searchAnalyzer: Analyzer? = nil,
                searchQuoteAnalyzer: Analyzer? = nil,
                fielddata: Bool? = nil,
                termVector: TermVector? = nil,
                boost: Float? = nil,
                eagerGlobalOrdinals: Bool? = nil,
                indexOptions: TextIndexOptions? = nil,
                norms: Bool? = nil,
                similarity: SimilarityType? = nil,
                ignoreAbove: Int? = 2147483647,
                nullValue: String? = nil) {
        
        self.index = index
        self.store = store
        self.fields = fields
        self.boost = boost
        self.eagerGlobalOrdinals = eagerGlobalOrdinals
        self.indexOptions = indexOptions
        self.norms = norms
        self.similarity = similarity
        
        self.analyzer = analyzer
        self.searchAnalyzer = searchAnalyzer
        self.searchQuoteAnalyzer = searchQuoteAnalyzer
        
        self.fielddata = fielddata
        self.termVector = termVector
    }
    
    /// :nodoc:
    public func definedNormalizers() -> [Normalizer] {
        var normalizers = [Normalizer]()
        if let fields = self.fields {
            for (_, field) in fields {
                normalizers += field.definedNormalizers()
            }
        }
        return normalizers
    }
    
    /// :nodoc:
    public func definedAnalyzers() -> [Analyzer] {
        var analyzers = [Analyzer]()
        if let fields = self.fields {
            for (_, field) in fields {
                analyzers += field.definedAnalyzers()
            }
        }
        if let analyzer = analyzer {
            analyzers.append(analyzer)
        }
        if let searchAnalyzer = searchAnalyzer {
            analyzers.append(searchAnalyzer)
        }
        if let searchQuoteAnalyzer = searchQuoteAnalyzer {
            analyzers.append(searchQuoteAnalyzer)
        }
        return analyzers
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(boost, forKey: .boost)
        try container.encodeIfPresent(eagerGlobalOrdinals, forKey: .eagerGlobalOrdinals)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(index, forKey: .index)
        try container.encodeIfPresent(indexOptions, forKey: .indexOptions)
        try container.encodeIfPresent(norms, forKey: .norms)
        try container.encodeIfPresent(store, forKey: .store)
        try container.encodeIfPresent(similarity, forKey: .similarity)
        
        if let analyzer = self.analyzer {
            try container.encode(analyzer.name, forKey: .analyzer)
        }
        if let searchAnalyzer = self.searchAnalyzer {
            try container.encode(searchAnalyzer.name, forKey: .searchAnalyzer)
        }
        if let searchQuoteAnalyzer = self.searchQuoteAnalyzer {
            try container.encode(searchQuoteAnalyzer.name, forKey: .searchQuoteAnalyzer)
        }
        
        try container.encodeIfPresent(fielddata, forKey: .fielddata)
        try container.encodeIfPresent(termVector, forKey: .termVector)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.boost = try container.decodeIfPresent(Float.self, forKey: .boost)
        self.eagerGlobalOrdinals = try container.decodeIfPresent(Bool.self, forKey: .eagerGlobalOrdinals)
        self.fields = try container.decodeIfPresent([String: TextField].self, forKey: .fields)
        self.index = try container.decodeIfPresent(Bool.self, forKey: .index)
        self.indexOptions = try container.decodeIfPresent(TextIndexOptions.self, forKey: .indexOptions)
        self.norms = try container.decodeIfPresent(Bool.self, forKey: .norms)
        self.store = try container.decodeIfPresent(Bool.self, forKey: .store)
        self.similarity = try container.decodeIfPresent(SimilarityType.self, forKey: .similarity)
        self.fielddata = try container.decodeIfPresent(Bool.self, forKey: .fielddata)
        self.termVector = try container.decodeIfPresent(TermVector.self, forKey: .termVector)
        
        if let analysis = decoder.getAnalysis() {
            if let analyzer = try container.decodeIfPresent(String.self, forKey: .analyzer) {
                self.analyzer = analysis.analyzer(named: analyzer)
            }
            if let searchAnalyzer = try container.decodeIfPresent(String.self, forKey: .searchAnalyzer) {
                self.searchAnalyzer = analysis.analyzer(named: searchAnalyzer)
            }
            if let searchQuoteAnalyzer = try container.decodeIfPresent(String.self, forKey: .searchQuoteAnalyzer) {
                self.searchQuoteAnalyzer = analysis.analyzer(named: searchQuoteAnalyzer)
            }
        }
    }
}
