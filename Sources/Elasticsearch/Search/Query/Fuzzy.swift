import Foundation

/**
 The fuzzy query uses similarity based on Levenshtein edit distance. The fuzzy
 query generates all possible matching terms that are within the maximum edit
 distance specified in fuzziness and then checks the term dictionary to find
 out which of those generated terms actually exist in the index.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-fuzzy-query.html)
 */
public struct Fuzzy: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.fuzzy

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

    private struct Inner: Codable {
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

    /// :nodoc:
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
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.key = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Fuzzy.Inner(from: innerDecoder)
        self.value = inner.value
        self.fuzziness = inner.fuzziness
        self.prefixLength = inner.prefixLength
        self.maxExpansions = inner.maxExpansions
        self.transpositions = inner.transpositions
    }
}
