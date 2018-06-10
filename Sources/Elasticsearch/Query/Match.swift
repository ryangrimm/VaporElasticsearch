import Foundation

public struct Match: QueryElement {
    public var codingKey = "match"

    let key: String
    let value: String
    let `operator`: String?
    let fuzziness: Int?

    public init(
        key: String,
        value: String,
        operator: String? = nil,
        fuzziness: Int? = nil
    ) {
        self.key = key
        self.value = value
        self.operator = `operator`
        self.fuzziness = fuzziness
    }

    struct Inner: Encodable {
        let value: String
        let `operator`: String?
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
}
