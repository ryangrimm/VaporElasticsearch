import HTTP
import Crypto

public class ElasticsearchIndexBuilder: Encodable {
    public var indexName: String
    public var mapping = ElasticsearchIndexType(doc: DocumentTypeSettings())
    public var aliases = [String: ElasticsearchIndexAlias]()
    public var settings: ElasticsearchIndexSettings

    enum CodingKeys: String, CodingKey {
        case mapping = "mappings"
        case aliases
        case settings
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.mapping, forKey: .mapping)
        try container.encode(self.settings, forKey: .settings)
        if (aliases.count > 0) {
            try container.encode(self.aliases, forKey: .aliases)
        }
    }
    
    public init(indexName: String, dynamicMapping: Bool = false, enableQuerying: Bool = true) {
        self.indexName = indexName
        self.mapping.doc.enabled = enableQuerying
        self.mapping.doc.dynamic = dynamicMapping
        self.settings = ElasticsearchIndexSettings()
    }
    
    @discardableResult
    public func indexSettings(_ index: IndexSettings) -> Self {
        self.settings.index = index
        return self
    }
    
    @discardableResult
    public func alias(name: String, routing: String? = nil) -> Self {
        let alias = ElasticsearchIndexAlias(routing: routing)
        aliases[name] = alias
        return self
    }
    
    @discardableResult
    public func property(key: String, type: Mappable) -> Self {
        mapping.doc.properties[key] = type
        
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
    
    @discardableResult
    public func add(metaKey: String, metaValue: String) -> Self {
        if let meta = mapping.doc.meta, meta.userDefined == nil {
            mapping.doc.meta!.userDefined = [String: String]()
        }
        mapping.doc.meta!.userDefined![metaKey] = metaValue
        return self
    }
    
    internal func create(client: ElasticsearchClient) -> Future<Void> {
        do {
            let propertiesJSON = try JSONEncoder().encode(self.mapping.doc.properties.mapValues { AnyMap($0) })
            let digest = try SHA1.hash(propertiesJSON)
            if let _ = self.mapping.doc.meta {
                self.mapping.doc.meta!.private.propertiesHash = digest.hexEncodedString()
            }

            let body = try JSONEncoder().encode(self)
            return client.send(HTTPMethod.PUT, to: "/\(indexName)", with: body).map { response -> Void in
                return
            }
        } catch {
            return client.worker.future(error: error)
        }
    }
}
