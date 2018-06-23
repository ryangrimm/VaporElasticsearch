import Foundation

public struct SpanNear: QueryElement, SpanQuery {
    /// :nodoc:
    public static var typeKey = QueryElementMap.spanNear
    
    let clauses: [SpanQueryElement]
    let slop: Int?
    let inOrder: Bool?
    
    enum CodingKeys: String, CodingKey {
        case clauses
        case slop
        case inOrder = "in_order"
    }
    
    public init(_ clauses: [SpanQueryElement], slop: Int? = nil, inOrder: Bool? = nil) {
        self.clauses = clauses
        self.slop = slop
        self.inOrder = inOrder
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var clausesContainer = container.nestedUnkeyedContainer(forKey: .clauses)
        for clause in self.clauses {
            var clauseContainer = clausesContainer.nestedContainer(keyedBy: DynamicKey.self)
            try clauseContainer.encode(AnySpanQuery(clause), forKey: DynamicKey(stringValue: type(of: clause).typeKey.rawValue)!)
        }
        try container.encodeIfPresent(slop, forKey: .slop)
        try container.encodeIfPresent(inOrder, forKey: .inOrder)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clauses = try container.decode([AnySpanQuery].self, forKey: .clauses).map { $0.base } as! [SpanQueryElement]
        self.slop = try container.decodeIfPresent(Int.self, forKey: .slop)
        self.inOrder = try container.decodeIfPresent(Bool.self, forKey: .inOrder)
    }
}
