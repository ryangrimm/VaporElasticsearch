import Foundation

public struct Exists: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.exists

    /// :nodoc:
    public var codingKey = "exists"

    let field: String

    public init(field: String) {
        self.field = field
    }

    enum CodingKeys: String, CodingKey {
        case field
    }
}
