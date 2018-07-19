import Foundation

/**
 The `MatchPhrasePrefix` is the same as match_phrase, except that it allows for prefix matches on the last term in the text.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-match-query-phrase-prefix.html)
 */
public struct MatchPhrasePrefix: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.matchPhrasePrefix

    let field: String
    let query: String
    let analyzer: String?
    let maxExpansions: Int?
    let boost: Decimal?
    
    public init(field: String, query: String, analyzer: String? = nil, maxExpansions: Int? = nil, boost: Decimal? = nil) {
        self.field = field
        self.query = query
        self.analyzer = analyzer
        self.maxExpansions = maxExpansions
        self.boost = boost
    }
    
    private struct Inner: Codable {
        let query: String
        let analyzer: String?
        let maxExpansions: Int?
        let boost: Decimal?
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        
        let inner = MatchPhrasePrefix.Inner(query: self.query, analyzer: self.analyzer, maxExpansions: self.maxExpansions, boost: self.boost)
        try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue

        let inner = try container.decode(MatchPhrasePrefix.Inner.self, forKey: key!)
        self.query = inner.query
        self.analyzer = inner.analyzer
        self.maxExpansions = inner.maxExpansions
        self.boost = inner.boost
    }
}
