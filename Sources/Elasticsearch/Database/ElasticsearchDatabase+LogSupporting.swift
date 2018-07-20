extension ElasticsearchDatabase: LogSupporting {
    /// See `LogSupporting`.
    public static func enableLogging(_ logger: DatabaseLogger, on conn: ElasticsearchDatabase.Connection) {
        conn.logger = logger
    }
}
