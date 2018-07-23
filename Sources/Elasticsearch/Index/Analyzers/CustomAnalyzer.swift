
import Foundation

public struct CustomAnalyzer: Analyzer, ModifiesIndex {
    /// :nodoc:
    public static var typeKey = AnalyzerType.fingerprint
    
    public let type = typeKey.rawValue
    public let name: String
    public var tokenizer: Tokenizer
    public var charFilter: [CharacterFilter]?
    public var filter: [TokenFilter]?
    public var positionIncrementGap: Int? = nil

    enum CodingKeys: String, CodingKey {
        case type
        case tokenizer
        case charFilter = "char_filter"
        case filter
        case positionIncrementGap = "position_increment_gap"
    }
    
    public init(name: String,
                tokenizer: Tokenizer,
                filter: [TokenFilter]? = nil,
                characterFilter: [CharacterFilter]? = nil,
                positionIncrementGap: Int? = nil) throws {

        if name != "analyzer" {
            throw ElasticsearchError(identifier: "invalid_name", reason: "'analyzer' cannot be used as a name", source: .capture())
        }
        
        self.name = name
        self.tokenizer = tokenizer
        self.filter = filter
        self.charFilter = characterFilter
        self.positionIncrementGap = positionIncrementGap
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(tokenizer.name, forKey: .tokenizer)
        
        var charFilterContainer = container.nestedUnkeyedContainer(forKey: .charFilter)
        if let charFilter = self.charFilter {
            for filter in charFilter {
                try charFilterContainer.encode(filter.name)
            }
        }
        
        var tokenFilterContainer = container.nestedUnkeyedContainer(forKey: .charFilter)
        if let tokenFilter = self.filter {
            for filter in tokenFilter {
                try tokenFilterContainer.encode(filter.name)
            }
        }
        
        try container.encodeIfPresent(positionIncrementGap, forKey: .positionIncrementGap)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (decoder.codingPath.last?.stringValue)!
        
        self.positionIncrementGap = try container.decodeIfPresent(Int.self, forKey: .positionIncrementGap)
        
        if let analysis = decoder.getAnalysis() {
            let tokenizer = try container.decode(String.self, forKey: .tokenizer)
            self.tokenizer = analysis.tokenizer(named: tokenizer)!
            
            if let charFilters = try container.decodeIfPresent([String].self, forKey: .charFilter) {
                self.charFilter = charFilters.map { analysis.characterFilter(named: $0)! }
            }
            if let tokenFilters = try container.decodeIfPresent([String].self, forKey: .filter) {
                self.filter = tokenFilters.map { analysis.tokenFilter(named: $0)! }
            }
        }
        else {
            // This should never be called
            self.tokenizer = StandardTokenizer()
        }
    }
    
    public func modifyBeforeSending(index: ElasticsearchIndex) {
        if let charFilters = self.charFilter {
            for filter in charFilters {
                index.settings.analysis.add(characterFilter: AnyCharacterFilter(filter))
            }
        }
        
        if let tokenFilters = self.filter {
            for filter in tokenFilters {
                index.settings.analysis.add(tokenFilter: AnyTokenFilter(filter))
            }
        }
        
        index.settings.analysis.add(tokenizer: AnyTokenizer(self.tokenizer))
    }
}
