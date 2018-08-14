import DatabaseKit
import Service

/// Provides base `Elasticsearch` services such as database and connection.
public final class ElasticsearchProvider: Provider {
    /// See `Provider.repositoryName`
    public static let repositoryName = "elasticsearch"
    
    public let config: ElasticsearchClientConfig
    
    /// Creates a new `ElasticsearchProvider`.
    public init() {
        self.config = ElasticsearchClientConfig()
    }
    
    public init(_ config: ElasticsearchClientConfig) {
        self.config = config
    }
    
    /// See `Provider.register`
    public func register(_ services: inout Services) throws {
        try services.register(DatabaseKitProvider())
        services.register(self.config)
        services.register(ElasticsearchDatabase.self)
        services.register { (container) -> DatabasesConfig in
            let esDb = ElasticsearchDatabase(config: self.config)
            
            var databases = DatabasesConfig()
            databases.add(database: esDb, as: .elasticsearch)
            return databases
        }
        
        if config.enableKeyedCache {
            try services.register(KeyedCacheMapping(indexName: config.keyedCacheIndexName))
        }
        
        services.register(KeyedCache.self) { container -> ElasticsearchCache in
            let pool = try container.connectionPool(to: .elasticsearch)
            return .init(pool: pool)
        }
    }
    
    /// See `Provider.boot`
    public func didBoot(_ container: Container) throws -> Future<Void> {
        return .done(on: container)
    }
}

struct KeyedCacheMapping: ElasticsearchIndex {
    let indexName: String
    let documentSettings = DocumentSettings(dynamic: true, enabled: false)
    
    init(indexName: String) {
        self.indexName = indexName
    }
}

/// MARK: Services
extension ElasticsearchClientConfig: ServiceType {
    /// See `ServiceType.makeService(for:)`
    public static func makeService(for worker: Container) throws -> ElasticsearchClientConfig {
        return .init()
    }
}
extension ElasticsearchDatabase: ServiceType {
    /// See `ServiceType.makeService(for:)`
    public static func makeService(for worker: Container) throws -> ElasticsearchDatabase {
        return try .init(config: worker.make())
    }
}

public typealias ElasticsearchCache = DatabaseKeyedCache<ConfiguredDatabase<ElasticsearchDatabase>>
