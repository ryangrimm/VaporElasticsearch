import Foundation

public protocol QueryElement: Codable {
    static var typeKey: QueryElementMap { get }

    var codingKey: String { get set }
}

public struct Query<T: QueryElement>: Codable {
    let query: T

    public init(_ query: T) {
        self.query = query
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(query, forKey: DynamicKey(stringValue: query.codingKey)!)
    }
}
