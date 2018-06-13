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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        self.values = try container.decode([String].self, forKey: key!)
    }
}
