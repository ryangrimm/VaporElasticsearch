import Foundation

public struct Terms: QueryElement {
    public static var typeKey = QueryElementMap.terms

    public var codingKey = "terms"

    let key: String
    let values: [String]

    public init(key: String, values: [String]) {
        self.key = key
        self.values = values
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(values, forKey: DynamicKey(stringValue: key)!)
    }
}
