import Foundation


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

public protocol ElasticsearchType: Codable {
}

protocol ElasticsearchStringType: Codable {
    var boost: Float { get set }
    var eagerGlobalOrdinals: Bool { get set }
    var fields: [ESTextField]? { get set }
    var index: Bool { get set }
    var indexOptions: ESTypeIndexOptions { get set }
    var norms: Bool { get set }
    var store: Bool { get set }
    var similarity: ESTypeSimilarity { get set }
}

protocol ElasticsearchNumberType: Codable {
    associatedtype numberType
    
    var coerce: Bool { get set }
    var boost: Float { get set }
    var docValues: Bool { get set }
    var ignoreMalformed: Bool { get set }
    var index: Bool { get set }
    var nullValue: numberType? { get set }
    var store: Bool { get set }
}
