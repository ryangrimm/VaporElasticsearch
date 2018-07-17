
public enum TextIndexOptions: String, Codable {
    case docs = "docs"
    case freqs = "freqs"
    case positions = "positions"
    case offsets = "offsets"
}

public enum SimilarityType: String, Codable {
    case bm25 = "BM25"
    case classic = "classic"
    case boolean = "boolean"
}

public enum TermVector: String, Codable {
    case no = "no"
    case yes = "yes"
    case withPositions = "with_positions"
    case withPositionsOffsets = "with_position_offsets"
}

public enum TextFieldType: String, Codable {
    case text = "text"
    case keyword = "keyword"
}

public struct TextField: Codable {
    var type: TextFieldType
    var analyzer: String?
    var normalizer: String?

    public init(
        type: TextFieldType,
        analyzer: String? = nil,
        normalizer: String? = nil) {

        self.type = type
        self.analyzer = analyzer
        self.normalizer = normalizer
    }
}

public protocol Mappable: Codable {
    static var typeKey: MapType { get }

}
