import Foundation

public struct CommonTerms: QueryElement {
    public static var typeKey = QueryElementMap.commonTerms
    
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        
        let inner = CommonTerms.Inner(query: self.query, cutoffFrequency: self.cutoffFrequency, lowFreqOperator: self.lowFreqOperator, minimumShouldMatch: self.minimumShouldMatch)
        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
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
