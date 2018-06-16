public enum QueryElementMap : String, Codable {
    
    case boolQuery = "bool"
    case exists
    case fuzzy
    case ids
    case match
    case matchAll = "match_all"
    case matchNone = "match_none"
    case matchPhrase = "match_phrase"
    case multiMatch = "multi_match"
    case prefix
    case range
    case regexp
    case term
    case terms
    case wildcard
    case matchPhasePrefix = "match_phrase_prefix"
    case commonTerms
    case script
    case spanTerm = "span_term"
    case spanFirst = "span_first"
    
    var metatype: QueryElement.Type {
        switch self {
        case .boolQuery:
            return BoolQuery.self
        case .exists:
            return Exists.self
        case .fuzzy:
            return Fuzzy.self
        case .ids:
            return IDs.self
        case .match:
            return Match.self
        case .matchAll:
            return MatchAll.self
        case .matchNone:
            return MatchNone.self
        case .matchPhrase:
            return MatchPhrase.self
        case .multiMatch:
            return MultiMatch.self
        case .prefix:
            return Prefix.self
        case .range:
            return Range.self
        case .regexp:
            return Regexp.self
        case .term:
            return Term.self
        case .terms:
            return Terms.self
        case .wildcard:
            return Wildcard.self
        case .matchPhasePrefix:
            return MatchPhrasePrefix.self
        case .commonTerms:
            return CommonTerms.self
        case .script:
            return ScriptQuery.self
        case .spanTerm:
            return SpanTerm.self
        case .spanFirst:
            return SpanFirst.self
        }
    }
}

internal struct AnyQueryElement : Codable {
    public var base: QueryElement
    
    init(_ base: QueryElement) {
        self.base = base
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        let type = QueryElementMap(rawValue: key!.stringValue)!
        let innerDecoder = try container.superDecoder(forKey: key!)
        self.base = try type.metatype.init(from: innerDecoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

