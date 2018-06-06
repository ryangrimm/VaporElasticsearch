import Foundation


public enum ESTypeIndexOptions: String {
    case docs = "docs"
    case freqs = "freqs"
    case positions = "positions"
    case offsets = "offsets"
}

public enum ESTypeSimilarity: String {
    case bm25 = "BM25"
    case classic = "classic"
    case boolean = "boolean"
}

public enum ESTypeTermVector: String {
    case no = "no"
    case yes = "yes"
    case withPositions = "with_positions"
    case withPositionsOffsets = "with_position_offsets"
}

public enum ESTextFieldType: String {
    case text = "text"
    case keyword = "keyword"
}

public struct ESTextField {
    var name: String
    var type: ESTextFieldType
    var analyzer: String?
}

public protocol ElasticsearchType {
    var key: String { get set }
}

protocol ElasticsearchStringType {
    var boost: Float { get set }
    var eagerGlobalOrdinals: Bool { get set }
    var fields: [ESTextField]? { get set }
    var index: Bool { get set }
    var indexOptions: ESTypeIndexOptions { get set }
    var norms: Bool { get set }
    var store: Bool { get set }
    var similarity: ESTypeTermVector { get set }
}

protocol ElasticsearchNumberType {
    associatedtype numberType
    
    var coerce: Bool { get set }
    var boost: Float { get set }
    var docValues: Bool { get set }
    var ignoreMalformed: Bool { get set }
    var index: Bool { get set }
    var nullValue: numberType? { get set }
    var store: Bool { get set }
}
