import Foundation

public struct Term: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.term
    
    /// :nodoc:
    public var codingKey = "term"

    let key: String
    let value: String
    let boost: Decimal?

    public init(key: String, value: String, boost: Decimal? = nil) {
        self.key = key
        self.value = value
        self.boost = boost
    }

    private struct Inner: Codable {
        let value: String
        let boost: Decimal?
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Term.Inner(value: value, boost: boost)

        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Term.Inner(from: innerDecoder)
        self.value = inner.value
        self.boost = inner.boost
    }
}
