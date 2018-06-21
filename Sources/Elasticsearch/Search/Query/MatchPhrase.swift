import Foundation

public struct MatchPhrase: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.matchPhrase

    /// :nodoc:
    public var codingKey = "match_phrase"

    let key: String
    let query: String
    let analyzer: String?

    public init(key: String, query: String, analyzer: String? = nil) {
        self.key = key
        self.query = query
        self.analyzer = analyzer
    }
    
    private struct Inner: Codable {
        let query: String
        let analyzer: String?
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        
        let inner = MatchPhrase.Inner(query: self.query, analyzer: self.analyzer)
        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        
        let inner = try container.decode(MatchPhrase.Inner.self, forKey: key!)
        self.query = inner.query
        self.analyzer = inner.analyzer
    }
}
