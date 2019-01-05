import Foundation

public struct SuggestContainer: Encodable {
    public let suggests: [Suggest]

    public init(suggests: [Suggest]) {
        self.suggests = suggests
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var suggestNode = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .suggest)

        try suggests.forEach { suggest in
            try suggestNode.encode(suggest, forKey: DynamicKey(stringValue: suggest.name)!)
        }
    }

    enum CodingKeys: String, CodingKey {
        case suggest
    }
}
