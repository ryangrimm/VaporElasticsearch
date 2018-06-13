import Foundation

public protocol QueryElement: Codable {
    static var typeKey: QueryElementMap { get }

    var codingKey: String { get set }
}

public struct Query: Encodable {
    let query: QueryElement

    public init(_ query: QueryElement) {
        self.query = query
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: query.codingKey)!)
    }
}
