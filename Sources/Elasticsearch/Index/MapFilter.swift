public struct MapFilter: Mappable {
    /// :nodoc:
    public static var typeKey = MapType.filter

    public let type: String
    public var name: String?
    public var synonyms: [String]?

    public init(type: String, name: String? = nil, synonyms: [String]? = nil) {

        self.type = type
        self.name = name
        self.synonyms = synonyms
    }
}
