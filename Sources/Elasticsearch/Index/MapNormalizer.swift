public struct MapNormalizer: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.normalizer

    public var filter: [String]?

    public init(filter: [String]? = []) {

        self.filter = filter
    }

    private enum CodingKeys : CodingKey {
        case filter
    }
}