import Foundation

public struct Fuzzy: QueryElement {
    public var codingKey = "fuzzy"

    let key: String
    let value: String
    let fuzziness: Int?
    let prefixLength: Int?
    let maxExpansions: Int?
    let transpositions: Bool?

    public init(
        key: String,
        value: String,
        fuzziness: Int? = nil,
        prefixLength: Int? = nil,
        maxExpansions: Int? = nil,
        transpositions: Bool? = nil
    ) {
        self.key = key
        self.value = value
        self.fuzziness = fuzziness
        self.prefixLength = prefixLength
        self.maxExpansions = maxExpansions
        self.transpositions = transpositions
    }

    struct Inner: Encodable {
        let value: String
        let fuzziness: Int?
        let prefixLength: Int?
        let maxExpansions: Int?
        let transpositions: Bool?

        enum CodingKeys: String, CodingKey {
            case value
            case fuzziness
            case prefixLength = "prefix_length"
            case maxExpansions = "max_expansions"
            case transpositions
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Fuzzy.Inner(
            value: value,
            fuzziness: fuzziness,
            prefixLength: prefixLength,
            maxExpansions: maxExpansions,
            transpositions: transpositions
        )

        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
}
