import DatabaseKit
import Service
import HTTP

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

        services.register(KeyedCache.self) { container -> ElasticsearchCache in
            let pool = try container.connectionPool(to: .elasticsearch)
            return .init(pool: pool)
        }
    }
    
    /// See `Provider.boot`
    
    public func willBoot(_ container: Container) throws -> Future<Void> {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
        let config = try container.make(ElasticsearchClientConfig.self)
        return ElasticsearchClient.connect(config: config, on: group).flatMap(to: Void.self) { client in
            
            var indexFutures = [Future<Void>]()
            for model in client.config.registeredModels {
                let future = client.fetchIndex(name: model.indexName).flatMap { index -> Future<Void> in
                    if index != nil {
                        client.logger?.record(query: model.indexName + " index exists")
                        return .done(on: container)
                    }
                    
                    let body = try model.generateIndexJSON()
                    return client.send(HTTPMethod.PUT, to: "/\(model.indexName)", with: body).map { response -> Void in
                        return
                    }
                }
                indexFutures.append(future)
                
            }
            
            if config.enableKeyedCache {
                let model = config.keyedCacheIndexModel
                let future = client.fetchIndex(name: model.indexName).flatMap { index -> Future<Void> in
                    if index != nil {
                        client.logger?.record(query: model.indexName + " index exists")
                        return .done(on: container)
                    }
                    
                    let body = try model.generateIndexJSON()
                    return client.send(HTTPMethod.PUT, to: "/\(model.indexName)", with: body).map { response -> Void in
                        return
                    }
                }
                indexFutures.append(future)
            }
            
            return indexFutures.flatten(on: group)
        }
    }
    
    /// See `Provider.boot`
    public func didBoot(_ container: Container) throws -> Future<Void> {
        return .done(on: container)
    }
}

struct KeyedCacheMapping: ElasticsearchModel, Reflectable {
    static var indexName = "vapor_keyed_cache"
    static var allowDynamicKeys = true
    static var enableSearching = false
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
