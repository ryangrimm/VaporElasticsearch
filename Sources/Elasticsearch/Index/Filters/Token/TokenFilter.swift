import Foundation


public protocol TokenFilter: Codable {
    static var typeKey: TokenFilterType { get }
    var type: String { get }
    var name: String { get }
}

public protocol BuiltinTokenFilter {
    init()
}

public protocol BasicTokenFilter: TokenFilter {
    init()
    func encode(to encoder: Encoder) throws
}

extension BasicTokenFilter {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.type)
    }
}

/// :nodoc:
public enum TokenFilterType: String, Codable {
    case standard
    case asciiFolding = "ascii_folding"
    case length
    case uppercase
    case lowercase
    case nGram
    case edgeNGram
    case porterStem = "porter_stem"
    case kStem = "kstem"
    case reverse
    case synonym
    case trim
    case classic
    case apostrophe
    case decimalDigit = "decimal_digit"
    
    var metatype: TokenFilter.Type {
        switch self {
        case .standard:
            return StandardFilter.self
        case .asciiFolding:
            return ASCIIFoldingFilter.self
        case .length:
            return LengthFilter.self
        case .uppercase:
            return UppercaseFilter.self
        case .lowercase:
            return LowercaseFilter.self
        case .nGram:
            return NGramFilter.self
        case .edgeNGram:
            return EdgeNGramFilter.self
        case .porterStem:
            return PorterStemFilter.self
        case .kStem:
            return KStemFilter.self
        case .reverse:
            return ReverseFilter.self
        case .synonym:
            return SynonymFilter.self
        case .trim:
            return TrimFilter.self
        case .classic:
            return ClassicFilter.self
        case .apostrophe:
            return ApostropheFilter.self
        case .decimalDigit:
            return DecimalDigitFilter.self
        }
    }
    
    enum Builtins: String, CodingKey {
        case standard
        case asciiFolding = "ascii_folding"
        case uppercase
        case lowercase
        case porterStem = "porter_stem"
        case kStem = "kstem"
        case reverse
        case trim
        case classic
        case apostrophe
        case decimalDigit = "decimal_digit"
        
        var metatype: BuiltinTokenFilter.Type {
            switch self {
            case .standard:
                return StandardFilter.self
            case .asciiFolding:
                return ASCIIFoldingFilter.self
            case .uppercase:
                return UppercaseFilter.self
            case .lowercase:
                return LowercaseFilter.self
            case .porterStem:
                return PorterStemFilter.self
            case .kStem:
                return KStemFilter.self
            case .reverse:
                return ReverseFilter.self
            case .trim:
                return TrimFilter.self
            case .classic:
                return ClassicFilter.self
            case .apostrophe:
                return ApostropheFilter.self
            case .decimalDigit:
                return DecimalDigitFilter.self
            }
        }
    }
}

public struct AnyTokenFilter : Codable {
    var base: TokenFilter
    
    init(_ base: TokenFilter) {
        self.base = base
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        
        let type = try container.decode(TokenFilterType.self, forKey: DynamicKey(stringValue: "type")!)
        self.base = try type.metatype.init(from: decoder)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}
