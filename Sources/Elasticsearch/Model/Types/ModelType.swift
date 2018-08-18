
import Foundation

public protocol ModelType: Codable {
    static var backingType: Mappable.Type { get }
}
