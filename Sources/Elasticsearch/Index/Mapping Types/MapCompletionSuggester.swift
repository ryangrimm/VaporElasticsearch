/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapCompletionSuggester: Mappable, DefinesAnalyzers {
    /// :nodoc:
    public static var typeKey = MapType.completionSuggester
    
    /// Holds the string that Elasticsearch uses to identify the mapping type
    public let type = typeKey.rawValue
    public let analyzer: Analyzer?
    public let searchAnalyzer: Analyzer?
    public let preserveSeparators: Bool?
    public let preservePositionIncrements: Bool?
    public let maxInputLength: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case analyzer
        case searchAnalyzer = "search_analyzer"
        case preserveSeparators = "preserve_separators"
        case preservePositionIncrements = "preserve_position_increments"
        case maxInputLength = "max_input_length"
    }
    
    public init(analyzer: Analyzer? = nil,
                searchAnalyzer: Analyzer? = nil,
                preserveSeparators: Bool? = nil,
                preservePositionIncrements: Bool? = nil,
                maxInputLength: Int? = nil) {
    
        self.analyzer = analyzer
        self.searchAnalyzer = searchAnalyzer
        self.preserveSeparators = preserveSeparators
        self.preservePositionIncrements = preservePositionIncrements
        self.maxInputLength = maxInputLength
    }
    
    public func definedAnalyzers() -> [Analyzer] {
        var analyzers = [Analyzer]()
        if let analyzer = self.analyzer {
            analyzers.append(analyzer)
        }
        if let searchAnalyzer = self.searchAnalyzer {
            analyzers.append(searchAnalyzer)
        }
        return analyzers
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let analyzer = self.analyzer {
            try container.encode(analyzer.name, forKey: .analyzer)
        }
        if let searchAnalyzer = self.searchAnalyzer {
            try container.encode(searchAnalyzer.name, forKey: .searchAnalyzer)
        }
        try container.encodeIfPresent(preserveSeparators, forKey: .preserveSeparators)
        try container.encodeIfPresent(preservePositionIncrements, forKey: .preservePositionIncrements)
        try container.encodeIfPresent(maxInputLength, forKey: .maxInputLength)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.preserveSeparators = try container.decodeIfPresent(Bool.self, forKey: .preserveSeparators)
        self.preservePositionIncrements = try container.decodeIfPresent(Bool.self, forKey: .preservePositionIncrements)
        self.maxInputLength = try container.decodeIfPresent(Int.self, forKey: .maxInputLength)
        
        if let analysis = decoder.analysis() {
            let analyzer = try container.decodeIfPresent(String.self, forKey: .analyzer)
            if let analyzer = analyzer {
                self.analyzer = analysis.analyzer(named: analyzer)
            } else {
                self.analyzer = nil
            }
            
            let searchAnalyzer = try container.decodeIfPresent(String.self, forKey: .searchAnalyzer)
            if let searchAnalyzer = searchAnalyzer {
                self.searchAnalyzer = analysis.analyzer(named: searchAnalyzer)
            } else {
                self.searchAnalyzer = nil
            }
        }
        else {
            self.analyzer = nil
            self.searchAnalyzer = nil
        }
    }
}
