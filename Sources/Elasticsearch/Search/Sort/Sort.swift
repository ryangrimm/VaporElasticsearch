import Foundation

public struct Sort: Codable {
    let key: String
    let order: SortOrder

    public init(_ key: String, _ order: SortOrder) {
        self.key = key
        self.order = order
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys[0]
        self.key = key.stringValue

        let valuesContainer = try container.nestedContainer(keyedBy: NestedKeys.self, forKey: key)
        self.order = try valuesContainer.decode(SortOrder.self, forKey: .order)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: NestedKeys.self, forKey: DynamicKey(stringValue: key)!)

        try valuesContainer.encode(order, forKey: .order)
    }

    enum NestedKeys: String, CodingKey {
        case order
    }
}
