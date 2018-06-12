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
        }
    }
}

public struct AnyQueryElement : Codable {
    public var base: QueryElement
    
    init(_ base: QueryElement) {
        self.base = base
    }
    
    private enum CodingKeys : CodingKey {
        case type
        case base
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(QueryElementMap.self, forKey: .type)
        self.base = try type.metatype.init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

