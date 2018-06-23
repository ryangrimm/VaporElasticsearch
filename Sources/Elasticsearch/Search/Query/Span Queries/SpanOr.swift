import Foundation

public struct SpanOr: QueryElement, SpanQuery {
    /// :nodoc:
    public static var typeKey = QueryElementMap.spanOr
    
    let clauses: [SpanQueryElement]
    
    enum CodingKeys: String, CodingKey {
        case clauses
    }
    
    public init(_ clauses: [SpanQueryElement]) {
        self.clauses = clauses
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var clausesContainer = container.nestedUnkeyedContainer(forKey: .clauses)
        for clause in self.clauses {
            var clauseContainer = clausesContainer.nestedContainer(keyedBy: DynamicKey.self)
            try clauseContainer.encode(AnySpanQuery(clause), forKey: DynamicKey(stringValue: type(of: clause).typeKey.rawValue)!)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clauses = try container.decode([AnySpanQuery].self, forKey: .clauses).map { $0.base } as! [SpanQueryElement]
    }
}
