/*
 These structs define all of the types that Elasticsearch can store,
 how they map to Swift types and allows the user to configure what
 the mapping should be like in their index.
 
 The list of types in Elasticsearch can be found at:
 https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html
 */

public class ESTypeGeoShape: ESType {
    public enum GeoShapePrefixTree: String, Codable {
        case geohash = "geohash"
        case quadtree = "quadtree"
    }
    
    public enum GeoShapePrecision: String, Codable {
        case `in` = "geohash"
        case inch = "quadtree"
        case yd = "yd"
        case yard = "yard"
        case mi = "mi"
        case miles = "miles"
        case km = "km"
        case kilometers = "kilometers"
        case m = "m"
        case meters = "meters"
        case cm = "cm"
        case centimeters = "centimeters"
        case mm = "mm"
        case millimeters = "millimeters"
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
    
    
    let type = "geo_shape"
    
    var tree: GeoShapePrefixTree? = .geohash
    var precision: GeoShapePrecision? = .meters
    var treeLevels: String?
    var strategy: GeoShapeStrategy? = .recursive
    var distanceErrorPct: Float? = 0.025
    var orientation: GeoShapeOrientation? = .ccw
    var pointsOnly: Bool? = false
    var ignoreMalformed: Bool? = false
    
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        super.init()
        
        tree = try container.decodeIfPresent(GeoShapePrefixTree.self, forKey: .tree)
        precision = try container.decodeIfPresent(GeoShapePrecision.self, forKey: .precision)
        treeLevels = try container.decodeIfPresent(String.self, forKey: .treeLevels)
        strategy = try container.decodeIfPresent(GeoShapeStrategy.self, forKey: .strategy)
        distanceErrorPct = try container.decodeIfPresent(Float.self, forKey: .distanceErrorPct)
        orientation = try container.decodeIfPresent(GeoShapeOrientation.self, forKey: .orientation)
        pointsOnly = try container.decodeIfPresent(Bool.self, forKey: .pointsOnly)
        ignoreMalformed = try container.decodeIfPresent(Bool.self, forKey: .ignoreMalformed)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(precision, forKey: .precision)
        try container.encodeIfPresent(treeLevels, forKey: .treeLevels)
        try container.encodeIfPresent(strategy, forKey: .strategy)
        try container.encodeIfPresent(distanceErrorPct, forKey: .distanceErrorPct)
        try container.encodeIfPresent(orientation, forKey: .orientation)
        try container.encodeIfPresent(pointsOnly, forKey: .pointsOnly)
        try container.encodeIfPresent(ignoreMalformed, forKey: .ignoreMalformed)
    }
    
    override init() {
        super.init()
    }
}


