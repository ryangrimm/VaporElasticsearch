/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public struct MapCompletionSuggester: Mappable {
    static var typeKey = MapType.completionSuggester
    
    let type = "compleation"
    
    var analyzer: String?
    var searchAnalyzer: String?
    var preserveSeparators: Bool?
    var preservePositionIncrements: Bool?
    var maxInputLength: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case analyzer
        case searchAnalyzer = "search_analyzer"
        case preserveSeparators = "preserve_separators"
        case preservePositionIncrements = "preserve_position_increments"
        case maxInputLength = "max_input_length"
    }
}
