import Foundation

/**
 Filters documents that only have the provided ids.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-ids-query.html)
 */
public struct IDs: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.ids

    public let values: [String]

    public init(_ values: [String]) {
        self.values = values
    }

    enum CodingKeys: String, CodingKey {
        case values
    }
}
