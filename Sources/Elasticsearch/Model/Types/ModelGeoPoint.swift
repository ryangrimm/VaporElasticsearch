
import Foundation

public typealias ModelGeoPoint = GeoPoint
extension ModelGeoPoint {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.geoPoint
        public var ignoreMalformed: Bool? = nil
        
        enum CodingKeys: String, CodingKey {
            case type
            case ignoreMalformed = "ignore_malformed"
        }
        
        public init() { }
        
        public init(ignoreMalformed: Bool? = nil) {
            self.ignoreMalformed = ignoreMalformed
        }
    }
}
