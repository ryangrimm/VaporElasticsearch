import HTTP
import Crypto

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
    
    struct DefaultType: Codable {
        var doc: DocumentTypeSettings
        
        enum CodingKeys: String, CodingKey {
            case doc = "_doc"
        }
    }
    
    struct Alias: Codable {
        var routing: String?
    }
    
    var client: ElasticsearchClient? = nil
    var indexName: String? = nil
    var mappings = DefaultType(doc: DocumentTypeSettings())
    var aliases = [String: Alias]()
    var settings: Settings

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
    
    
    internal static func fetch(indexName: String, client: ElasticsearchClient) throws -> Future<ElasticsearchIndex> {
        return try client.send(HTTPMethod.GET, to: "/\(indexName)").map(to: ElasticsearchIndex.self) { response in
            let wrapper = try JSONDecoder().decode(FetchWrapper.self, from: response)
            wrapper.indexMappingValue.indexName = wrapper.indexName
            
            for (_, tokenizer) in wrapper.indexMappingValue.settings.analysis.tokenizers {
                if tokenizer.base is ModifiesIndex {
                    var modify = tokenizer.base as! IndexModifies
                    modify.modifyAfterReceiving(index: wrapper.indexMappingValue)
                }
            }
            
            for (_, property) in wrapper.indexMappingValue.mappings.doc.properties {
                if property.base is ModifiesIndex {
                    var modify = property.base as! IndexModifies
                    modify.modifyAfterReceiving(index: wrapper.indexMappingValue)
                }
            }
            
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
        
        if type is ModifiesIndex {
            let modify = type as! ModifiesIndex
            modify.modifyBeforeSending(index: self)
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
    
    public func tokenizer(named: String) -> Tokenizer? {
        let builtin = TokenizerType.Builtins(rawValue: named)
        if let builtin = builtin {
            return builtin.metatype.init() as? Tokenizer
        }
        
        if let tokenizer = self.settings.analysis.tokenizers[named] {
            return tokenizer.base
        }
        return nil
    }
    
    public func tokenFilter(named: String) -> TokenFilter? {
        let builtin = TokenFilterType.Builtins(rawValue: named)
        if let builtin = builtin {
            return builtin.metatype.init() as? TokenFilter
        }
        
        if let filter = self.settings.analysis.filters[named] {
            return filter.base
        }
        return nil
    }
    
    public func characterFilter(named: String) -> CharacterFilter? {
        if let charFilter = self.settings.analysis.characterFilters[named] {
            return charFilter.base
        }
        return nil
    }
    
    public func analyzer(named: String) -> Analyzer? {
        let builtin = AnalyzerType.Builtins(rawValue: named)
        if let builtin = builtin {
            return builtin.metatype.init() as? Analyzer
        }
        
        if let analyzer = self.settings.analysis.analyzers[named] {
            return analyzer.base
        }
        return nil
    }
    
    public func normalizer(named: String) -> Normalizer? {
        if let normalizer = self.settings.analysis.normalizers[named] {
            return normalizer.base
        }
        return nil
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
