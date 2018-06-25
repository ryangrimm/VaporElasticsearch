import Foundation

/**
 The `MatchPhrase` query analyzes the text and creates a phrase query out of the analyzed text.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-match-query-phrase.html)
 */
public struct MatchPhrase: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.matchPhrase

    let field: String
    let query: String
    let analyzer: String?

    public init(field: String, query: String, analyzer: String? = nil) {
        self.field = field
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
        try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue
        
        let inner = try container.decode(MatchPhrase.Inner.self, forKey: key!)
        self.query = inner.query
        self.analyzer = inner.analyzer
    }
}
