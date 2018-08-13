
import HTTP

internal struct ElasticsearchIndexFetcher: Decodable {
    struct FetchWrapper: Decodable {
        var indexName: String
        var configuration: ElasticsearchIndexFetcher
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicKey.self)
            
            let key = container.allKeys.first!
            indexName = key.stringValue
            configuration = try container.decode(ElasticsearchIndexFetcher.self, forKey: key)
        }
    }
    
    public var indexName: String? = nil
    public var mapping = ElasticsearchIndexType(doc: DocumentTypeSettings())
    public var aliases = [String: ElasticsearchIndexAlias]()
    public var settings: ElasticsearchIndexSettings
    
    enum CodingKeys: String, CodingKey {
        case mapping = "mappings"
        case aliases
        case settings
    }
    
    internal static func fetch(indexName: String, client: ElasticsearchClient) -> Future<ElasticsearchFetchedIndex?> {
        return client.send(HTTPMethod.GET, to: "/\(indexName)").map(to: ElasticsearchFetchedIndex?.self) { response in
            // This is being done in three passes because the filters, analyzers and tokenizers
            // need to be populated before the properties. This needs to be done so they can
            // fetch their analyzers at the time of decoding. It's a little unfortunate but
            // but overall not a big deal as it should be a very rare function to be called.
            
            if let response = response {
                // First pass gets filters and analyzers
                let filtersAnalyzers = try JSONDecoder().decode(ExtractFiltersAnalyzers.self, from: response)
                var analysis = Analysis()
                analysis.filters = filtersAnalyzers.filters
                analysis.characterFilters = filtersAnalyzers.characterFilters
                analysis.analyzers = filtersAnalyzers.analyzers
                
                let analysisPass = JSONDecoder()
                analysisPass.userInfo(analysis: analysis)
                let fullAnalysis = try analysisPass.decode(FetchWrapper.self, from: response)
                
                let fullPass = JSONDecoder()
                fullPass.userInfo(analysis: fullAnalysis.configuration.settings.analysis)
                let wrapper = try fullPass.decode(FetchWrapper.self, from: response)
                
                return ElasticsearchFetchedIndex(indexName: wrapper.indexName, mapping: wrapper.configuration.mapping, aliases: wrapper.configuration.aliases, settings: wrapper.configuration.settings)
            }
            
            return nil
        }
    }
}

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
        if settingsContainer.contains(DynamicKey(stringValue: "analysis")!) {
            let analysisContainer = try settingsIndexContainer.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: "analysis")!)
            
            if let analyzers = (try analysisContainer.decodeIfPresent([String: AnyAnalyzer].self, forKey: DynamicKey(stringValue: "analyzer")!)) {
                self.analyzers = analyzers.mapValues { $0.base }
            } else {
                self.analyzers = [:]
            }
            if let filters = (try analysisContainer.decodeIfPresent([String: AnyTokenFilter].self, forKey: DynamicKey(stringValue: "filter")!)) {
                self.filters = filters.mapValues { $0.base }
            } else {
                self.filters = [:]
            }
            if let characterFilters = (try analysisContainer.decodeIfPresent([String: AnyCharacterFilter].self, forKey: DynamicKey(stringValue: "char_filter")!)) {
                self.characterFilters = characterFilters.mapValues { $0.base }
            } else {
                self.characterFilters = [:]
            }
        }
        else {
            self.analyzers = [:]
            self.filters = [:]
            self.characterFilters = [:]
        }
    }
}