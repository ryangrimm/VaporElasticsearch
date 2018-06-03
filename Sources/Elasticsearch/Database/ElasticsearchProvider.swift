import DatabaseKit
import Service

/// Provides base `Elasticsearch` services such as database and connection.
public final class ElasticsearchProvider: Provider {
    /// See `Provider.repositoryName`
    public static let repositoryName = "elasticsearch"
    
    /// Creates a new `ElasticsearchProvider`.
    public init() {}
    
    /// See `Provider.register`
    public func register(_ services: inout Services) throws {
        try services.register(DatabaseKitProvider())
        services.register(ElasticsearchClientConfig.self)
        services.register(ElasticsearchDatabase.self)
        var databases = DatabasesConfig()
        databases.add(database: ElasticsearchDatabase.self, as: .elasticsearch)
        services.register(databases)
    }
    
    /// See `Provider.boot`
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
