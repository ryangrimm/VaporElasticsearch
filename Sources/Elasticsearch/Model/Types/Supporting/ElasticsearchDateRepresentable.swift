
import Foundation

public protocol ElasticsearchDateRepresentable: Codable {
    func stringRepresentation() -> String
}

extension Date: ElasticsearchDateRepresentable {
    public func stringRepresentation() -> String {
        return self.description
    }
}

public struct RelativeDate: ElasticsearchDateRepresentable {
    public let format: String
    
    public func stringRepresentation() -> String {
        return self.format
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
