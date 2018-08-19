import Foundation

public struct ChainableNestedProperties {
    var props = [String: Mappable]()
    
    @discardableResult
    public mutating func property(key: String, type: Mappable) -> ChainableNestedProperties {
        self.props[key] = type
        return self
    }
    
    public func properties() -> [String: Mappable]? {
        return props
    }
}
