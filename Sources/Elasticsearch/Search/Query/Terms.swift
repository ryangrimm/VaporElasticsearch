import Foundation

/**
 Filters documents that have fields that match any of the provided terms (not analyzed).

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-terms-query.html)
 */
public struct Terms: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.terms

    public let field: String
    public let values: [String]?
    public let index: String?
    public let type: String?
    public let id: String?
    public let path: String?

    public init(
        field: String,
        values: [String]? = nil,
        index: String? = nil,
        type: String? = nil,
        id: String? = nil,
        path: String? = nil
    ) {
        self.field = field
        self.values = values
        self.index = index
        self.type = type
        self.id = id
        self.path = path
    }

    private struct Inner: Codable {
        let index: String?
        let type: String?
        let id: String?
        let path: String?
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        if values != nil {
            try container.encode(values, forKey: DynamicKey(stringValue: field)!)
        } else {
            let inner = Terms.Inner(
                index: index,
                type: type,
                id: id,
                path: path
            )
            try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
        }
    }

    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue

        do {
            self.values = try container.decode([String].self, forKey: key!)
            self.index = nil
            self.type = nil
            self.id = nil
            self.path = nil
        } catch {
            self.values = nil
            let innerDecoder = try container.superDecoder(forKey: key!)
            let inner = try Terms.Inner(from: innerDecoder)
            self.index = inner.index
            self.type = inner.type
            self.id = inner.id
            self.path = inner.path
        }
    }
}
