
import Foundation

public struct ModelGeoShape: ModelType {
    // NOTE: Implement
}

extension ModelGeoShape {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        public enum GeoShapePrefixTree: String, Codable {
            case geohash
            case quadtree
        }
        
        public enum GeoShapePrecision: String, Codable {
            case `in`
            case inch
            case yd
            case yard
            case mi
            case miles
            case km
            case kilometers
            case m
            case meters
            case cm
            case centimeters
            case mm
            case millimeters
        }
        
        public enum GeoShapeStrategy: String, Codable {
            case recursive = "recursive"
            case term = "term"
        }
        
        public enum GeoShapeOrientation: String, Codable {
            case right = "right"
            case ccw = "ccw"
            case counterclockwise = "counterclockwise"
            case left = "left"
            case cw = "cw"
            case clockwise = "clockwise"
        }
        
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.geoShape
        public var tree: GeoShapePrefixTree? = nil
        public var precision: GeoShapePrecision? = nil
        public var treeLevels: String? = nil
        public var strategy: GeoShapeStrategy? = nil
        public var distanceErrorPct: Float? = nil
        public var orientation: GeoShapeOrientation? = nil
        public var pointsOnly: Bool? = nil
        public var ignoreMalformed: Bool? = nil
        
        enum CodingKeys: String, CodingKey {
            case type
            case tree
            case precision
            case treeLevels = "tree_levels"
            case strategy = "null_value"
            case distanceErrorPct = "distance_error_pct"
            case orientation
            case pointsOnly = "points_only"
            case ignoreMalformed = "ignore_malformed"
        }
        
        public init() { }
        
        public init(tree: GeoShapePrefixTree? = nil,
                    precision: GeoShapePrecision? = nil,
                    treeLevels: String? = nil,
                    strategy: GeoShapeStrategy? = nil,
                    distanceErrorPct: Float? = nil,
                    orientation: GeoShapeOrientation? = nil,
                    pointsOnly: Bool? = nil,
                    ignoreMalformed: Bool? = nil) {
            
            self.tree = tree
            self.precision = precision
            self.treeLevels = treeLevels
            self.strategy = strategy
            self.distanceErrorPct = distanceErrorPct
            self.orientation = orientation
            self.pointsOnly = pointsOnly
            self.ignoreMalformed = ignoreMalformed
        }
    }
}
