import Foundation

public struct MatchPhrase: QueryElement {
    public static var typeKey = QueryElementMap.matchPhrase

    public var codingKey = "match_phrase"

    let key: String
    let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(value, forKey: DynamicKey(stringValue: key)!)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        self.value = try container.decode(String.self, forKey: key!)
    }
}
