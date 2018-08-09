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
        services.register(ElasticsearchDatabase.self)
        services.register { (container) -> DatabasesConfig in
            let esDb = try ElasticsearchDatabase(config: self.config)
            
            var databases = DatabasesConfig()
            databases.add(database: esDb, as: .elasticsearch)
            return databases
        }
        
        services.register(KeyedCache.self) { container -> ElasticsearchCache in
            let pool = try container.connectionPool(to: .elasticsearch)
            return .init(pool: pool)
        }
    }
    
    /// See `Provider.boot`
    public func willBoot(_ worker: Container) throws -> Future<Void> {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
        return ElasticsearchClient.connect(config: self.config, on: group).flatMap(to: Void.self) { client in
            return try ElasticsearchDatabase.setupKeyedCache(client: client, on: worker)
        }
    }
    
    public func didBoot(_ worker: Container) throws -> Future<Void> {
        return .done(on: worker)
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
