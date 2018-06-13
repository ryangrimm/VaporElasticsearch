import Foundation

public struct Prefix: QueryElement {
    public static var typeKey = QueryElementMap.prefix

    public var codingKey = "prefix"

    let key: String
    let value: String
    let boost: Decimal?

    public init(key: String, value: String, boost: Decimal?) {
        self.key = key
        self.value = value
        self.boost = boost
    }

    public struct Inner: Codable {
        let value: String
        let boost: Decimal?
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Prefix.Inner(value: value, boost: boost)

        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Prefix.Inner(from: innerDecoder)
        self.value = inner.value
        self.boost = inner.boost
    }
}
