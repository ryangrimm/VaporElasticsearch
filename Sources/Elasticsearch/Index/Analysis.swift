
import Foundation

public struct Analysis: Codable {
    public var filters: [String: AnyTokenFilter]
    public var characterFilters: [String: AnyCharacterFilter]
    public var analyzers: [String: AnyAnalyzer]
    public var normalizers: [String: AnyNormalizer]
    public var tokenizers: [String: AnyTokenizer]
    
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
            self.filters = filters
        } else {
            self.filters = [:]
        }
        if let characterFilters = try container.decodeIfPresent([String: AnyCharacterFilter].self, forKey: .characterFilters) {
            self.characterFilters = characterFilters
        } else {
            self.characterFilters = [:]
        }
        if let analyzers = try container.decodeIfPresent([String: AnyAnalyzer].self, forKey: .analyzers) {
            self.analyzers = analyzers
        } else {
            self.analyzers = [:]
        }
        if let normalizers = try container.decodeIfPresent([String: AnyNormalizer].self, forKey: .normalizers) {
            self.normalizers = normalizers
        } else {
            self.normalizers = [:]
        }
        if let tokenizers = try container.decodeIfPresent([String: AnyTokenizer].self, forKey: .tokenizers) {
            self.tokenizers = tokenizers
        } else {
            self.tokenizers = [:]
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
            return tokenizer.base
        }
        return nil
    }
    
    public func tokenFilter(named: String) -> TokenFilter? {
        let builtin = TokenFilterType.Builtins(rawValue: named)
        if let builtin = builtin {
            return builtin.metatype.init() as? TokenFilter
        }
        
        if let filter = self.filters[named] {
            return filter.base
        }
        return nil
    }
    
    public func characterFilter(named: String) -> CharacterFilter? {
        if let charFilter = self.characterFilters[named] {
            return charFilter.base
        }
        return nil
    }
    
    public func analyzer(named: String) -> Analyzer? {
        let builtin = AnalyzerType.Builtins(rawValue: named)
        if let builtin = builtin {
            return builtin.metatype.init() as? Analyzer
        }
        
        if let analyzer = self.analyzers[named] {
            return analyzer.base
        }
        return nil
    }
    
    public func normalizer(named: String) -> Normalizer? {
        if let normalizer = self.normalizers[named] {
            return normalizer.base
        }
        return nil
    }
    
    internal mutating func add(tokenFilter: AnyTokenFilter) {
        // If it's a builtin filter, don't add
        if TokenFilterType.Builtins(rawValue: tokenFilter.base.name) != nil {
            return
        }
        self.filters[tokenFilter.base.name] = tokenFilter
    }
    
    internal mutating func add(characterFilter: AnyCharacterFilter) {
        self.characterFilters[characterFilter.base.name] = characterFilter
    }
    
    internal mutating func add(tokenizer: AnyTokenizer) {
        // If it's a builtin tokenizer, don't add
        if TokenizerType.Builtins(rawValue: tokenizer.base.name) != nil {
            return
        }
        self.tokenizers[tokenizer.base.name] = tokenizer
    }
    
    internal mutating func add(analyzer: AnyAnalyzer) {
        // If it's a builtin analyzer, don't add
        if AnalyzerType.Builtins(rawValue: analyzer.base.name) != nil {
            return
        }
        self.analyzers[analyzer.base.name] = analyzer
    }
    
    internal mutating func add(normalizer: AnyNormalizer) {
        self.normalizers[normalizer.base.name] = normalizer
    }
}
