import Foundation

public struct Term: QueryElement {
    public static var typeKey = QueryElementMap.term
    
    public var codingKey = "term"

    let key: String
    let value: String
    let boost: Decimal?

    public init(key: String, value: String, boost: Decimal? = nil) {
        self.key = key
        self.value = value
        self.boost = boost
    }

    struct Inner: Encodable {
        let value: String
        let boost: Decimal?
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Term.Inner(value: value, boost: boost)

        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
}
