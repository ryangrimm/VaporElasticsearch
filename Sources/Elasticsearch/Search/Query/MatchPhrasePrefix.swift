import Foundation

public struct MatchPhrasePrefix: QueryElement {
    public static var typeKey = QueryElementMap.matchPhrase
    
    public var codingKey = "match_phrase_prefix"
    
    let key: String
    let query: String
    let analyzer: String?
    let maxExpansions: Int?
    
    public init(key: String, query: String, analyzer: String?, maxExpansions: Int?) {
        self.key = key
        self.query = query
        self.analyzer = analyzer
        self.maxExpansions = maxExpansions
    }
    
    public struct Inner: Codable {
        let query: String
        let analyzer: String?
        let maxExpansions: Int?
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        
        let inner = MatchPhrasePrefix.Inner(query: self.query, analyzer: self.analyzer, maxExpansions: self.maxExpansions)
        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue

        let inner = try container.decode(MatchPhrasePrefix.Inner.self, forKey: key!)
        self.query = inner.query
        self.analyzer = inner.analyzer
        self.maxExpansions = inner.maxExpansions
    }
}
