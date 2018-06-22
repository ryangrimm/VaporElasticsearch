import Foundation

/**
 The common terms query is a modern alternative to stopwords which improves the
 precision and recall of search results (by taking stopwords into account),
 without sacrificing performance.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-common-terms-query.html)
 */
public struct CommonTerms: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.commonTerms
    
    /// :nodoc:
    public var codingKey = "common"
    
    let key: String
    let query: String
    let cutoffFrequency: Float
    let lowFreqOperator: Operator?
    let minimumShouldMatch: Int?
    
    public init(key: String, query: String, cutoffFrequency: Float, lowFreqOperator: Operator?, minimumShouldMatch: Int?) {
        self.key = key
        self.query = query
        self.cutoffFrequency = cutoffFrequency
        self.lowFreqOperator = lowFreqOperator
        self.minimumShouldMatch = minimumShouldMatch
    }
    
    private struct Inner: Codable {
        let query: String
        let cutoffFrequency: Float
        let lowFreqOperator: Operator?
        let minimumShouldMatch: Int?
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        
        let inner = CommonTerms.Inner(query: self.query, cutoffFrequency: self.cutoffFrequency, lowFreqOperator: self.lowFreqOperator, minimumShouldMatch: self.minimumShouldMatch)
        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        
        let inner = try container.decode(CommonTerms.Inner.self, forKey: key!)
        self.query = inner.query
        self.cutoffFrequency = inner.cutoffFrequency
        self.lowFreqOperator = inner.lowFreqOperator
        self.minimumShouldMatch = inner.minimumShouldMatch
    }
}
