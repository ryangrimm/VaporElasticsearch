/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */


import Foundation

public struct ESTypeText:  ElasticsearchStringType, ElasticsearchType {
    let type = "text"
    
    // See ElasticsearchStringType
    var boost: Float = 1.0
    var eagerGlobalOrdinals: Bool = false
    var fields: [ESTextField]?
    var index: Bool = true
    var indexOptions: ESTypeIndexOptions = .positions
    var norms: Bool = true
    var store: Bool = false
    var similarity: ESTypeSimilarity = .bm25
    
    var analyzer: String?
    var searchAnalyzer: String?
    var searchQuoteAnalyzer: String?
    var fielddata: Bool = false
    var termVector: ESTypeTermVector = .no
    
    enum CodingKeys: String, CodingKey {
        case type
        case boost
        case eagerGlobalOrdinals = "eager_global_ordinals"
        case fields
        case index
        case indexOptions = "index_options"
        case norms
        case store
        case similarity
        case analyzer
        case searchAnalyzer = "search_analyzer"
        case searchQuoteAnalyzer = "search_quote_analyzer"
        case fielddata
        case termVector = "term_vector"
    }
    
    init() {
        
    }
}

public struct ESTypeKeyword: ElasticsearchStringType, ElasticsearchType {
    let type = "keyword"

    // See ElasticsearchStringType
    var boost: Float = 1.0
    var eagerGlobalOrdinals: Bool = false
    var fields: [ESTextField]?
    var index: Bool = true
    var indexOptions: ESTypeIndexOptions = .positions
    var norms: Bool = true
    var store: Bool = false
    var similarity: ESTypeSimilarity = .bm25

    var docValues: Bool = true
    var ignoreAbove: Int = 2147483647
    var nullValue: String?
    // var normalizer
    
    enum CodingKeys: String, CodingKey {
        case type
        case boost
        case eagerGlobalOrdinals = "eager_global_ordinals"
        case fields
        case index
        case indexOptions = "index_options"
        case norms
        case store
        case similarity
        case docValues = "doc_values"
        case ignoreAbove = "ignore_above"
        case nullValue = "null_value"
//        case normalizer
    }
}

public struct ESTypeLong: ElasticsearchNumberType, ElasticsearchType {
    typealias nullType = Int64
    
    let type = "long"
    
    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: nullType? = nil
    var store: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
    }
}

public struct ESTypeInteger: ElasticsearchNumberType, ElasticsearchType {
    typealias nullType = Int
    
    let type = "integer"

    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: nullType? = nil
    var store: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
    }
    
    init() {
    
    }
}

public struct ESTypeShort: ElasticsearchNumberType, ElasticsearchType {
    typealias nullType = Int16

    let type = "short"

    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: nullType? = nil
    var store: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
    }
}

public struct ESTypeByte: ElasticsearchNumberType, ElasticsearchType {
    typealias nullType = Int8
    
    let type = "byte"
    
    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: nullType? = nil
    var store: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
    }
}

public struct ESTypeDouble: ElasticsearchNumberType, ElasticsearchType {
    typealias nullType = Double
    
    let type = "double"

    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: nullType? = nil
    var store: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
    }
}

public struct ESTypeFloat: ElasticsearchNumberType, ElasticsearchType {
    typealias nullType = Float

    let type = "float"

    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: nullType? = nil
    var store: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
    }
}

public struct ESTypeHalfFloat: ElasticsearchNumberType, ElasticsearchType {
    typealias nullType = Float

    let type = "half_float"

    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: nullType? = nil
    var store: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
    }
}

public struct ESTypeScaledFloat: ElasticsearchNumberType, ElasticsearchType {
    typealias nullType = Float
    
    let type = "scaled_float"

    // See ElasticsearchNumberType
    var coerce: Bool = true
    var boost: Float = 1.0
    var docValues: Bool = true
    var ignoreMalformed: Bool = false
    var index: Bool = true
    var nullValue: nullType? = nil
    var store: Bool = false
    
    var scalingFactor: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case coerce
        case boost
        case docValues = "doc_values"
        case ignoreMalformed = "ignore_malformed"
        case index
        case nullValue = "null_value"
        case store
        case scalingFactor = "scaling_factor"
    }
}

public struct ESTypeDate {
    
}

public struct ESTypeBoolean {
    
}

public struct ESTypeBinary {
    
}

public struct ESTypeIntegerRange {
    
}

public struct ESTypeFloatRange {
    
}

public struct ESTypeLongRange {
    
}

public struct ESTypeDoubleRange {
    
}

public struct ESTypeDateRange {
    
}

public struct ESTypeArray {
    
}

public struct ESTypeObject {
    
}

public struct ESTypeNested {
    
}

public struct ESTypeGeoPoint {
    
}

public struct ESTypeGeoShape {
    
}

public struct ESTypeIPAddress {
    
}
