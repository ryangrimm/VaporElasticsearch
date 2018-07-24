import HTTP
import Crypto

internal struct ExtractFiltersAnalyzers: Decodable {
    public var filters: [String: TokenFilter]
    public var characterFilters: [String: CharacterFilter]
    public var analyzers: [String: Analyzer]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        
        let key = container.allKeys.first!
        let indexContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: key)
        let settingsContainer = try indexContainer.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: "settings")!)
        let settingsIndexContainer = try settingsContainer.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: "index")!)
        let analysisContainer = try settingsIndexContainer.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: "analysis")!)
        
        if let analyzers = (try analysisContainer.decodeIfPresent([String: AnyAnalyzer].self, forKey: DynamicKey(stringValue: "analyzer")!)) {
            self.analyzers = analyzers.mapValues { $0.base }
        }
        else {
            self.analyzers = [:]
        }
        if let filters = (try analysisContainer.decodeIfPresent([String: AnyTokenFilter].self, forKey: DynamicKey(stringValue: "filter")!)) {
            self.filters = filters.mapValues { $0.base }
        }
        else {
            self.filters = [:]
        }
        if let characterFilters = (try analysisContainer.decodeIfPresent([String: AnyCharacterFilter].self, forKey: DynamicKey(stringValue: "char_filter")!)) {
            self.characterFilters = characterFilters.mapValues { $0.base }
        }
        else {
            self.characterFilters = [:]
        }
    }
}

public class ElasticsearchIndex: Codable {
    
    struct FetchWrapper: Codable {
        var indexName: String
        var indexMappingValue: ElasticsearchIndex
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: DynamicKey.self)
            try container.encode(indexMappingValue, forKey: DynamicKey(stringValue: indexName)!)
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicKey.self)

            let key = container.allKeys.first!
            indexName = key.stringValue
            indexMappingValue = try container.decode(ElasticsearchIndex.self, forKey: key)
        }
    }
    
    public struct DefaultType: Codable {
        var doc: DocumentTypeSettings
        
        enum CodingKeys: String, CodingKey {
            case doc = "_doc"
        }
    }
    
    public struct Alias: Codable {
        var routing: String?
    }
    
    public var client: ElasticsearchClient? = nil
    public var indexName: String? = nil
    public var mappings = DefaultType(doc: DocumentTypeSettings())
    public var aliases = [String: Alias]()
    public var settings: Settings

    enum CodingKeys: String, CodingKey {
        case mappings
        case aliases
        case settings
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mappings = try container.decode(DefaultType.self, forKey: .mappings)
        self.aliases = try container.decode([String: Alias].self, forKey: .aliases)
        self.settings = try container.decode(Settings.self, forKey: .settings)
        print(self.settings)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.mappings, forKey: .mappings)
        try container.encode(self.settings, forKey: .settings)
        if (aliases.count > 0) {
            try container.encode(self.mappings, forKey: .mappings)
        }
    }
    
    internal static func fetch(indexName: String, client: ElasticsearchClient) throws -> Future<ElasticsearchIndex> {
        return try client.send(HTTPMethod.GET, to: "/\(indexName)").map(to: ElasticsearchIndex.self) { response in
            // This is being done in three passes because the filters, analyzers and tokenizers
            // need to be populated before the properties. This needs to be done so they can
            // fetch their analyzers at the time of decoding. It's a little unfortunate but
            // but overall not a big deal as it's a very rare function to be called.
            
            // First pass gets filters and analyzers
            let filtersAnalyzers = try JSONDecoder().decode(ExtractFiltersAnalyzers.self, from: response)
            var analysis = Analysis()
            analysis.filters = filtersAnalyzers.filters
            analysis.characterFilters = filtersAnalyzers.characterFilters
            analysis.analyzers = filtersAnalyzers.analyzers
            
            let analysisPass = JSONDecoder()
            analysisPass.setUserInfo(analysis: analysis)
            let fullAnalysis = try analysisPass.decode(FetchWrapper.self, from: response)

            let fullPass = JSONDecoder()
            fullPass.setUserInfo(analysis: fullAnalysis.indexMappingValue.settings.analysis)
            let wrapper = try fullPass.decode(FetchWrapper.self, from: response)
            
            return wrapper.indexMappingValue
        }
    }
    
    internal init(indexName: String, client: ElasticsearchClient, dynamicMapping: Bool = false, enableQuerying: Bool = true) {
        self.indexName = indexName
        self.client = client
        self.mappings.doc.enabled = enableQuerying
        self.mappings.doc.dynamic = dynamicMapping
        self.settings = Settings()
    }
    
    public func indexSettings(_ index: IndexSettings) -> Self {
        self.settings.index = index
        return self
    }
    
    public func alias(name: String, routing: String? = nil) -> Self {
        let alias = Alias(routing: routing)
        aliases[name] = alias
        return self
    }
    
    public func property(key: String, type: Mappable) -> Self {
        mappings.doc.properties[key] = AnyMap(type)
        
        if type is DefinesNormalizers {
            let type = type as! DefinesNormalizers
            for normalizer in type.definedNormalizers() {
                self.settings.analysis.add(normalizer: normalizer)
            }
        }
        
        if type is DefinesAnalyzers {
            let type = type as! DefinesAnalyzers
            for analyzer in type.definedAnalyzers() {
                self.settings.analysis.add(analyzer: analyzer)
                
                if analyzer is DefinesTokenizers {
                    let analyzer = analyzer as! DefinesTokenizers
                    for tokenizer in analyzer.definedTokenizers() {
                        self.settings.analysis.add(tokenizer: tokenizer)
                    }
                }
                if analyzer is DefinesTokenFilters {
                    let analyzer = analyzer as! DefinesTokenFilters
                    for tokenFilter in analyzer.definedTokenFilters() {
                        self.settings.analysis.add(tokenFilter: tokenFilter)
                    }
                }
                if analyzer is DefinesCharacterFilters {
                    let analyzer = analyzer as! DefinesCharacterFilters
                    for characterFilter in analyzer.definedCharacterFilters() {
                        self.settings.analysis.add(characterFilter: characterFilter)
                    }
                }
            }
        }
        
        return self
    }
    
    public func add(metaKey: String, metaValue: String) -> Self {
        if let meta = mappings.doc.meta, meta.userDefined == nil {
            mappings.doc.meta!.userDefined = [String: String]()
        }
        mappings.doc.meta!.userDefined![metaKey] = metaValue
        return self
    }
    
    public func create() throws -> Future<Void> {
        guard let name = indexName else {
            throw ElasticsearchError(identifier: "missing_indexName", reason: "Missing index name for index creation", source: .capture())
        }
        guard let _ = self.client else {
            throw ElasticsearchError(identifier: "missing_client", reason: "Missing client for index creation", source: .capture())
        }
        
        let propertiesJSON = try JSONEncoder().encode(self.mappings.doc.properties)
        let digest = try SHA1.hash(propertiesJSON)
        if let _ = self.mappings.doc.meta {
            self.mappings.doc.meta!.private.propertiesHash = digest.hexEncodedString()
        }
        
        let body = try JSONEncoder().encode(self)
        return try self.client!.send(HTTPMethod.PUT, to: "/\(name)", with: body).map(to: Void.self) { response in
        }
    }
    
    // TODO - should add an option to ignore if index isn't present
    internal static func delete(indexName: String, client: ElasticsearchClient) throws -> Future<Void> {
        return try client.send(HTTPMethod.DELETE, to: "/\(indexName)").map(to: Void.self) { response in
        }
    }
    
    public struct Settings: Codable {
        public var index: IndexSettings? = nil
        public var analysis = Analysis()
        
        init(index: IndexSettings? = nil) {
            self.index = index
        }
        
        enum CodingKeys: String, CodingKey {
            case index
            case analysis
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(index, forKey: .index)
            if analysis.isEmpty() == false {
                try container.encode(analysis, forKey: .analysis)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.index = try container.decodeIfPresent(IndexSettings.self, forKey: .index)
    
            let analysisContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .index)
            if let analysis = try analysisContainer.decodeIfPresent(Analysis.self, forKey: DynamicKey(stringValue: "analysis")!) {
                self.analysis = analysis
            }
            else {
                self.analysis = Analysis()
            }
        }
    }
}
