import Foundation

public struct Exists: QueryElement {
    public static var typeKey = QueryElementMap.exists

    public var codingKey = "exists"

    let field: String

    public init(field: String) {
        self.field = field
    }

    enum CodingKeys: String, CodingKey {
        case field
    }
}
