import Foundation

public struct QueryContainer<T: QueryElement>: Codable {
    let query: Query<T>?

    public init(_ query: Query<T>? = nil) {
        self.query = query
    }
}
