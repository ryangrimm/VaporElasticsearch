/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public struct MapText: Mappable, ModifiesIndex, IndexModifies {
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
    
    public var analyzer: Analyzer?
    public var searchAnalyzer: Analyzer?
    public var searchQuoteAnalyzer: Analyzer?
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

    public init(index: Bool? = true,
                store: Bool? = false,
                fields: [String: TextField]? = nil,
                analyzer: Analyzer? = nil,
                searchAnalyzer: Analyzer? = nil,
                searchQuoteAnalyzer: Analyzer? = nil,
                fielddata: Bool? = false,
                termVector: TermVector? = .no,
                boost: Float? = 1.0,
                eagerGlobalOrdinals: Bool? = false,
                indexOptions: TextIndexOptions? = nil,
                norms: Bool? = true,
                similarity: SimilarityType? = .bm25,
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
    
    public func modifyBeforeSending(index: ElasticsearchIndex) {
        if let fields = self.fields {
            for (_, field) in fields {
                if let analyzer = field.analyzer {
                    index.settings.analysis.add(analyzer: AnyAnalyzer(analyzer))
                }
                if let normalizer = field.normalizer {
                    index.settings.analysis.add(normalizer: AnyNormalizer(normalizer))
                }
            }
        }
        
        if let analyzer = analyzer {
            index.settings.analysis.add(analyzer: AnyAnalyzer(analyzer))
        }
        if let searchAnalyzer = searchAnalyzer {
            index.settings.analysis.add(analyzer: AnyAnalyzer(searchAnalyzer))
        }
        if let searchQuoteAnalyzer = searchQuoteAnalyzer {
            index.settings.analysis.add(analyzer: AnyAnalyzer(searchQuoteAnalyzer))
        }
    }

    public mutating func modifyAfterReceiving(index: ElasticsearchIndex) {
        if let name = self.analyzer?.name {
            self.analyzer = index.analyzer(named: name)
        }
        if let name = self.searchAnalyzer?.name {
            self.searchAnalyzer = index.analyzer(named: name)
        }
        if let name = self.searchQuoteAnalyzer?.name {
            self.searchQuoteAnalyzer = index.analyzer(named: name)
        }
        if let fields = self.fields {
            for (_, var field) in fields {
                if let analyzer = field.analyzer {
                    field.analyzer = index.analyzer(named: analyzer.name)
                }
                if let normalizer = field.normalizer {
                    field.normalizer = index.normalizer(named: normalizer.name)
                }
             }
        }
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
        
        let analyzer = try container.decodeIfPresent(String.self, forKey: .analyzer)
        if let analyzer = analyzer {
            self.analyzer = TempAnalyzer(name: analyzer)
        }
        let searchAnalyzer = try container.decodeIfPresent(String.self, forKey: .searchAnalyzer)
        if let searchAnalyzer = searchAnalyzer {
            self.searchAnalyzer = TempAnalyzer(name: searchAnalyzer)
        }
        let searchQuoteAnalyzer = try container.decodeIfPresent(String.self, forKey: .searchQuoteAnalyzer)
        if let searchQuoteAnalyzer = searchQuoteAnalyzer {
            self.searchQuoteAnalyzer = TempAnalyzer(name: searchQuoteAnalyzer)
        }
    }
}
