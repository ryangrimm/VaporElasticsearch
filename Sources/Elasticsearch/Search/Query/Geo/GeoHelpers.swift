
public enum GeoValidationMethod: String, Codable {
    case strict = "STRICT"
    case coerce = "COERCE"
    case ignoreMalformed = "IGNORE_MALFORMED"
}

public struct GeoPoint: Codable {
    let lat: Float?
    let lon: Float?
    let geoHash: String?
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
    
    public init(lat: Float, lon: Float) {
        self.lat = lat
        self.lon = lon
        self.geoHash = nil
    }
    
    public init(geoHash: String) {
        self.lat = nil
        self.lon = nil
        self.geoHash = geoHash
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        if geoHash != nil {
            var container = encoder.singleValueContainer()
            try container.encode(self.geoHash)
        }
        else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.lat, forKey: .lat)
            try container.encode(self.lon, forKey: .lon)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        var lat: Float?
        var lon: Float?
        var geoHash: String?
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            lat = try container.decode(Float.self, forKey: .lat)
            lon = try container.decode(Float.self, forKey: .lon)
            geoHash = nil
        }
        catch {
            let container = try decoder.singleValueContainer()
            geoHash = try container.decode(String.self)
            lat = nil
            lon = nil
        }
        
        self.lat = lat
        self.lon = lon
        self.geoHash = geoHash
    }
}
