
import Foundation

public protocol Aggregation: Encodable {
    static var typeKey: AggregationResponseMap { get }
    
    var codingKey: String { get set }
    var name: String { get set }
}

public enum OrderDirection: String, Encodable {
    case asc
    case desc
}
