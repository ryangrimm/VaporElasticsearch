
public enum ESTypeIndexOptions: String, Codable {
    case docs = "docs"
    case freqs = "freqs"
    case positions = "positions"
    case offsets = "offsets"
}

public enum ESTypeSimilarity: String, Codable {
    case bm25 = "BM25"
    case classic = "classic"
    case boolean = "boolean"
}

public enum ESTypeTermVector: String, Codable {
    case no = "no"
    case yes = "yes"
    case withPositions = "with_positions"
    case withPositionsOffsets = "with_position_offsets"
}

public enum ESTextFieldType: String, Codable {
    case text = "text"
    case keyword = "keyword"
}

public struct ESTextField: Codable {
    var name: String
    var type: ESTextFieldType
    var analyzer: String?
}

public class ESType: Codable {
    init() {
    }
}
