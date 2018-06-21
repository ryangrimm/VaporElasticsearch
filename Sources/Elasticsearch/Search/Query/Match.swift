import Foundation

public struct Match: QueryElement {
    public static var typeKey = QueryElementMap.match

    public var codingKey = "match"

    let key: String
    let value: String
    let `operator`: Operator?
    let fuzziness: Int?

    public init(
        key: String,
        value: String,
        operator: Operator? = nil,
        fuzziness: Int? = nil
    ) {
        self.key = key
        self.value = value
        self.operator = `operator`
        self.fuzziness = fuzziness
    }

    private struct Inner: Codable {
        let value: String
        let `operator`: Operator?
        let fuzziness: Int?

        enum CodingKeys: String, CodingKey {
            case value = "query"
            case `operator`
            case fuzziness
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Match.Inner(value: value, operator: `operator`, fuzziness: fuzziness)

        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Match.Inner(from: innerDecoder)
        self.value = inner.value
        self.`operator` = inner.`operator`
        self.fuzziness = inner.fuzziness
    }
}

public enum Operator: String, Codable {
    case and
    case or
}
