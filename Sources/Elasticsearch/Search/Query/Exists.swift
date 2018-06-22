import Foundation

/**
 Returns documents that have at least one non-null value in the original field.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-exists-query.html)
 */
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
