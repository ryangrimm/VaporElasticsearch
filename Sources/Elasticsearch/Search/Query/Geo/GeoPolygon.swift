import Foundation

/**
 A query allowing to define scripts as queries. They are typically used in a filter context.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-script-query.html)
 */
public struct GeoPolygon: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.geoPolygon
    
    let field: String
    let points: [GeoPoint]
    let name: String?
    let validationMethod: GeoValidationMethod?
    
    enum CodingKeys: String, CodingKey {
        case points
        case name = "_name"
        case validationMethod
    }
    
    public init(field: String, points: [GeoPoint], name: String? = nil, validationMethod: GeoValidationMethod? = nil) {
        self.field = field
        self.points = points
        self.name = name
        self.validationMethod = validationMethod
    }
    
    private struct Inner: Codable {
        let points: [GeoPoint]
        let name: String?
        let validationMethod: GeoValidationMethod?
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        
        let inner = GeoPolygon.Inner(points: self.points, name: self.name, validationMethod: self.validationMethod)
        try container.encode(inner, forKey: DynamicKey(stringValue: self.field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let field = container.allKeys.first
        self.field = field!.stringValue
        
        let inner = try container.decode(GeoPolygon.Inner.self, forKey: field!)
        self.points = inner.points
        self.name = inner.name
        self.validationMethod = inner.validationMethod
    }
}
