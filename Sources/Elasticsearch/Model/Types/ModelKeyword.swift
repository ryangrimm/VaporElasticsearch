
import Foundation

public struct ModelKeyword: ModelType, ExpressibleByStringLiteral, CustomStringConvertible {
    public typealias StringLiteralType = String
    
    public var value: String
    
    public init(stringLiteral value: String) {
        self.value = value
    }
    
    public var description: String {
        return value
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}

extension ModelKeyword {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable, DefinesNormalizers, DefinesAnalyzers {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.keyword
        public var boost: Float?
        public var eagerGlobalOrdinals: Bool?
        public var fields: [String: TextField]?
        public var copyTo: [String]?
        public var index: Bool?
        public var indexOptions: TextIndexOptions?
        public var norms: Bool?
        public var store: Bool?
        public var similarity: SimilarityType?
        public var docValues: Bool?
        public var ignoreAbove: Int?
        public var nullValue: String?
        public var normalizer: Normalizer?
        
        enum CodingKeys: String, CodingKey {
            case type
            case boost
            case eagerGlobalOrdinals = "eager_global_ordinals"
            case fields
            case copyTo = "copy_to"
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
        
        public init() { }
        
        public init(docValues: Bool? = nil,
                    index: Bool? = nil,
                    store: Bool? = nil,
                    fields: [String: TextField]? = nil,
                    copyTo: [String]? = nil,
                    boost: Float? = nil,
                    eagerGlobalOrdinals: Bool? = nil,
                    indexOptions: TextIndexOptions? = nil,
                    norms: Bool? = nil,
                    similarity: SimilarityType? = nil,
                    ignoreAbove: Int? = nil,
                    nullValue: String? = nil,
                    normalizer: Normalizer? = nil) {
            
            self.docValues = docValues
            self.index = index
            self.store = store
            self.fields = fields
            self.copyTo = copyTo
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
        public func definedNormalizers() -> [Normalizer] {
            var normalizers = [Normalizer]()
            if let fields = self.fields {
                for (_, field) in fields {
                    normalizers += field.definedNormalizers()
                }
            }
            if let normalizer = self.normalizer {
                normalizers.append(normalizer)
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
            return analyzers
        }
        
        /// :nodoc:
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(docValues, forKey: .docValues)
            try container.encodeIfPresent(index, forKey: .index)
            try container.encodeIfPresent(store, forKey: .store)
            try container.encodeIfPresent(fields, forKey: .fields)
            try container.encodeIfPresent(copyTo, forKey: .copyTo)
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
            
            self.boost = try container.decodeIfPresent(Float.self, forKey: .boost)
            self.eagerGlobalOrdinals = try container.decodeIfPresent(Bool.self, forKey: .eagerGlobalOrdinals)
            self.fields = try container.decodeIfPresent([String: TextField].self, forKey: .fields)
            self.copyTo = try container.decodeIfPresent([String].self, forKey: .copyTo)
            self.index = try container.decodeIfPresent(Bool.self, forKey: .index)
            self.indexOptions = try container.decodeIfPresent(TextIndexOptions.self, forKey: .indexOptions)
            self.norms = try container.decodeIfPresent(Bool.self, forKey: .norms)
            self.store = try container.decodeIfPresent(Bool.self, forKey: .store)
            self.similarity = try container.decodeIfPresent(SimilarityType.self, forKey: .similarity)
            self.docValues = try container.decodeIfPresent(Bool.self, forKey: .docValues)
            self.ignoreAbove = try container.decodeIfPresent(Int.self, forKey: .ignoreAbove)
            self.nullValue = try container.decodeIfPresent(String.self, forKey: .nullValue)
            
            if let analysis = decoder.analysis() {
                let normalizer = try container.decodeIfPresent(String.self, forKey: .normalizer)
                if let normalizer = normalizer {
                    self.normalizer = analysis.normalizer(named: normalizer)
                } else {
                    self.normalizer = nil
                }
            } else {
                self.normalizer = nil
            }
        }
    }
}
