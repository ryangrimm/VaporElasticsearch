import Foundation

public struct IDs: QueryElement {
    public var codingKey = "ids"

    let values: [String]

    public init(_ values: [String]) {
        self.values = values
    }

    enum CodingKeys: String, CodingKey {
        case values
    }
}
