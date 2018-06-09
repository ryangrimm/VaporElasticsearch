import Foundation

public struct IDs: QueryElement {
    public typealias QueryType = IDs
    public var codingKey = "ids"

    let values: [String]

    public init(_ values: [String]) {
        self.values = values
    }

    enum CodingKeys: String, CodingKey {
        case values
    }
}
