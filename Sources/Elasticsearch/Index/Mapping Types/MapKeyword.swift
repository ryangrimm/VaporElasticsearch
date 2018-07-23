/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

import Foundation

public struct MapKeyword: Mappable, ModifiesIndex {
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
    public var normalizer: Normalizer?
    
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
                fields: [String: TextField]? = nil,
                boost: Float? = 1.0,
                eagerGlobalOrdinals: Bool? = false,
                indexOptions: TextIndexOptions? = nil,
                norms: Bool? = true,
                similarity: SimilarityType? = .bm25,
                ignoreAbove: Int? = 2147483647,
                nullValue: String? = nil,
                normalizer: Normalizer? = nil) {
        
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
    
    /// :nodoc:
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
        
        if let normalizer = self.normalizer {
            index.settings.analysis.add(normalizer: AnyNormalizer(normalizer))
        }
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(docValues, forKey: .docValues)
        try container.encodeIfPresent(index, forKey: .index)
        try container.encodeIfPresent(store, forKey: .store)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(boost, forKey: .boost)
        try container.encodeIfPresent(eagerGlobalOrdinals, forKey: .eagerGlobalOrdinals)
        try container.encodeIfPresent(indexOptions, forKey: .indexOptions)
        try container.encodeIfPresent(norms, forKey: .norms)
        try container.encodeIfPresent(similarity, forKey: .similarity)
        try container.encodeIfPresent(nullValue, forKey: .nullValue)

        if let normalizer = self.normalizer {
            try container.encode(normalizer.name, forKey: .normalizer)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let analysis = decoder.getAnalysis() {
            self.boost = try container.decodeIfPresent(Float.self, forKey: .boost)
            self.eagerGlobalOrdinals = try container.decodeIfPresent(Bool.self, forKey: .eagerGlobalOrdinals)
            self.fields = try container.decodeIfPresent([String: TextField].self, forKey: .fields)
            self.index = try container.decodeIfPresent(Bool.self, forKey: .index)
            self.indexOptions = try container.decodeIfPresent(TextIndexOptions.self, forKey: .indexOptions)
            self.norms = try container.decodeIfPresent(Bool.self, forKey: .norms)
            self.store = try container.decodeIfPresent(Bool.self, forKey: .store)
            self.similarity = try container.decodeIfPresent(SimilarityType.self, forKey: .similarity)
            self.docValues = try container.decodeIfPresent(Bool.self, forKey: .docValues)
            self.ignoreAbove = try container.decodeIfPresent(Int.self, forKey: .ignoreAbove)
            self.nullValue = try container.decodeIfPresent(String.self, forKey: .nullValue)
            
            let normalizer = try container.decodeIfPresent(String.self, forKey: .normalizer)
            if let normalizer = normalizer {
                self.normalizer = analysis.normalizer(named: normalizer)
            }
        }
    }
}
