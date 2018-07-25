import Foundation

/// :nodoc:
public protocol QueryElement: Codable {
    static var typeKey: QueryElementMap { get }
}

/// A `Query` starts the query portion of a search to be executed (as opposed to an `Aggregation`).
public struct Query: Codable {
    public let query: QueryElement

    enum CodingKeys: String, CodingKey {
        case query
    }
    
    public init(_ query: QueryElement) {
        self.query = query
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: type(of: query).typeKey.rawValue)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        let type = QueryElementMap(rawValue: key!.stringValue)!
        let innerDecoder = try container.superDecoder(forKey: key!)
        self.query = try type.metatype.init(from: innerDecoder)
    }
}
