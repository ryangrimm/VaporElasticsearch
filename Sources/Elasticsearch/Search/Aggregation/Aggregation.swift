
import Foundation

/// :nodoc:
public protocol Aggregation: Encodable {
    static var typeKey: AggregationResponseMap { get }
    
    var name: String { get set }
    var aggs: [Aggregation]? { get set }

}
