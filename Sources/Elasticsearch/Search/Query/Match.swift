import Foundation

/**
 Match queries accept text/numerics/dates, analyzes them, and constructs a query.

 The match query is of type boolean. It means that the text provided is
 analyzed and the analysis process constructs a boolean query from the provided
 text. The operator flag can be set to or or and to control the boolean clauses
 (defaults to or). The minimum number of optional should clauses to match can
 be set using the minimumShouldMatch parameter.

 The analyzer can be set to control which analyzer will perform the analysis
 process on the text. It defaults to the field explicit mapping definition, or
 the default search analyzer.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query.html)
 */
public struct Match: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.match

    public let field: String
    public let value: String
    public let `operator`: Operator?
    public let fuzziness: Int?
    public let boost: Decimal?

    public init(
        field: String,
        value: String,
        operator: Operator? = nil,
        fuzziness: Int? = nil,
        boost: Decimal? = nil
    ) {
        self.field = field
        self.value = value
        self.operator = `operator`
        self.fuzziness = fuzziness
        self.boost = boost
    }

    private struct Inner: Codable {
        let value: String
        let `operator`: Operator?
        let fuzziness: Int?
        let boost: Decimal?

        enum CodingKeys: String, CodingKey {
            case value = "query"
            case `operator`
            case fuzziness
            case boost
        }
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Match.Inner(value: value, operator: `operator`, fuzziness: fuzziness, boost: boost)

        try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Match.Inner(from: innerDecoder)
        self.value = inner.value
        self.`operator` = inner.`operator`
        self.fuzziness = inner.fuzziness
        self.boost = inner.boost
    }
}

public enum Operator: String, Codable {
    case and
    case or
}
