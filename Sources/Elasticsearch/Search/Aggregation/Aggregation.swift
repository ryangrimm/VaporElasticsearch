
import Foundation

/// :nodoc:
public protocol Aggregation: Encodable {
    static var typeKey: AggregationResponseMap { get }
    
    var codingKey: String { get set }
    var name: String { get set }
}

/// Specify a direction for order
///
/// - asc: Ascending
/// - desc: Descending
public enum OrderDirection: String, Encodable {
    case asc
    case desc
}
