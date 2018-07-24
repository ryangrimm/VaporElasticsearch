
import Foundation

public struct Analysis: Codable {
    public var filters: [String: TokenFilter]
    public var characterFilters: [String: CharacterFilter]
    public var analyzers: [String: Analyzer]
    public var normalizers: [String: Normalizer]
    public var tokenizers: [String: Tokenizer]
    
    enum CodingKeys: String, CodingKey {
        case filters = "filter"
        case characterFilters = "char_filter"
        case analyzers = "analyzer"
        case normalizers = "normalizer"
        case tokenizers = "tokenizer"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let filters = try container.decodeIfPresent([String: AnyTokenFilter].self, forKey: .filters) {
            self.filters = filters.mapValues { $0.base }
        } else {
            self.filters = [:]
        }
        if let characterFilters = try container.decodeIfPresent([String: AnyCharacterFilter].self, forKey: .characterFilters) {
            self.characterFilters = characterFilters.mapValues { $0.base }
        } else {
            self.characterFilters = [:]
        }
        if let analyzers = try container.decodeIfPresent([String: AnyAnalyzer].self, forKey: .analyzers) {
            self.analyzers = analyzers.mapValues { $0.base }
        } else {
            self.analyzers = [:]
        }
        if let normalizers = try container.decodeIfPresent([String: AnyNormalizer].self, forKey: .normalizers) {
            self.normalizers = normalizers.mapValues { $0.base }
        } else {
            self.normalizers = [:]
        }
        if let tokenizers = try container.decodeIfPresent([String: AnyTokenizer].self, forKey: .tokenizers) {
            self.tokenizers = tokenizers.mapValues { $0.base }
        } else {
            self.tokenizers = [:]
        }
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if self.filters.count > 0 {
            try container.encode(self.filters.mapValues { AnyTokenFilter($0) }, forKey: .filters)
        }
        if self.characterFilters.count > 0 {
            try container.encode(self.characterFilters.mapValues { AnyCharacterFilter($0) }, forKey: .characterFilters)
        }
        if self.analyzers.count > 0 {
            try container.encode(self.analyzers.mapValues { AnyAnalyzer($0) }, forKey: .analyzers)
        }
        if self.normalizers.count > 0 {
            try container.encode(self.normalizers.mapValues { AnyNormalizer($0) }, forKey: .normalizers)
        }
        if self.tokenizers.count > 0 {
            try container.encode(self.tokenizers.mapValues { AnyTokenizer($0) }, forKey: .tokenizers)
        }
    }
    
    public init() {
        self.filters = [:]
        self.characterFilters = [:]
        self.analyzers = [:]
        self.normalizers = [:]
        self.tokenizers = [:]
    }
    
    
    public func tokenizer(named: String) -> Tokenizer? {
        let builtin = TokenizerType.Builtins(rawValue: named)
        if let builtin = builtin {
            return builtin.metatype.init() as? Tokenizer
        }
        
        if let tokenizer = self.tokenizers[named] {
            return tokenizer
        }
        return nil
    }
    
    public func tokenFilter(named: String) -> TokenFilter? {
        let builtin = TokenFilterType.Builtins(rawValue: named)
        if let builtin = builtin {
            return builtin.metatype.init() as? TokenFilter
        }
        
        if let filter = self.filters[named] {
            return filter
        }
        return nil
    }
    
    public func characterFilter(named: String) -> CharacterFilter? {
        if let charFilter = self.characterFilters[named] {
            return charFilter
        }
        return nil
    }
    
    public func analyzer(named: String) -> Analyzer? {
        let builtin = AnalyzerType.Builtins(rawValue: named)
        if let builtin = builtin {
            return builtin.metatype.init() as? Analyzer
        }
        
        if let analyzer = self.analyzers[named] {
            return analyzer
        }
        return nil
    }
    
    public func normalizer(named: String) -> Normalizer? {
        if let normalizer = self.normalizers[named] {
            return normalizer
        }
        return nil
    }
    
    internal mutating func add(tokenFilter: TokenFilter) {
        // If it's a builtin filter, don't add
        if TokenFilterType.Builtins(rawValue: tokenFilter.name) != nil {
            return
        }
        self.filters[tokenFilter.name] = tokenFilter
    }
    
    internal mutating func add(characterFilter: CharacterFilter) {
        // If it's a builtin filter, don't add
        if CharacterFilterType.Builtins(rawValue: characterFilter.name) != nil {
            return
        }
        self.characterFilters[characterFilter.name] = characterFilter
    }
    
    internal mutating func add(tokenizer: Tokenizer) {
        // If it's a builtin tokenizer, don't add
        if TokenizerType.Builtins(rawValue: tokenizer.name) != nil {
            return
        }
        self.tokenizers[tokenizer.name] = tokenizer
    }
    
    internal mutating func add(analyzer: Analyzer) {
        // If it's a builtin analyzer, don't add
        if AnalyzerType.Builtins(rawValue: analyzer.name) != nil {
            return
        }
        self.analyzers[analyzer.name] = analyzer
    }
    
    internal mutating func add(normalizer: Normalizer) {
        self.normalizers[normalizer.name] = normalizer
    }
    
    internal func isEmpty() -> Bool {
        return filters.count == 0 && characterFilters.count == 0 && analyzers.count == 0 && normalizers.count == 0 && tokenizers.count == 0
    }
}
