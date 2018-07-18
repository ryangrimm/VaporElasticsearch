public struct MapAnalyzer: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.analyzer

    var tokenizer: String
    public var filter: [String]?

    public init(filter: [String]? = [], tokenizer: String) {

        self.filter = filter
        self.tokenizer = tokenizer
    }

    private enum CodingKeys : CodingKey {
        case filter
        case tokenizer
    }
}