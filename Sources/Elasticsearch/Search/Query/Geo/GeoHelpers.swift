
public enum GeoValidationMethod: String, Codable {
    case strict = "STRICT"
    case coerce = "COERCE"
    case ignoreMalformed = "IGNORE_MALFORMED"
}

public enum GeoPoint: Codable {
    case object(lat: Float, lon: Float)
    case string(lat: Float, lon: Float)
    case array(lat: Float, lon: Float)
    case geoHash(String)
    
    enum CodingKeys: CodingKey {
        case object
        case string
        case array
        case geoHash
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .object(let lat, let lon):
            var container = encoder.container(keyedBy: DynamicKey.self)
            try container.encode(lat, forKey: DynamicKey(stringValue: "lat")!)
            try container.encode(lon, forKey: DynamicKey(stringValue: "lon")!)
        case .string(let lat, let lon):
            var container = encoder.singleValueContainer()
            try container.encode("\(lat),\(lon)")
        case .array(let lat, let lon):
            var container = encoder.unkeyedContainer()
            try container.encode(lat)
            try container.encode(lon)
        case .geoHash(let hash):
            var container = encoder.singleValueContainer()
            try container.encode(hash)
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: DynamicKey.self)
            let lat = try container.decode(Float.self, forKey: DynamicKey(stringValue: "lat")!)
            let lon = try container.decode(Float.self, forKey: DynamicKey(stringValue: "lon")!)
            self = .object(lat: lat, lon: lon)
        } catch {
            do {
                var container = try decoder.unkeyedContainer()
                let lat = try container.decode(Float.self)
                let lon = try container.decode(Float.self)
                self = .array(lat: lat, lon: lon)
            } catch {
                do {
                    let container = try decoder.singleValueContainer()
                    let rawValue = try container.decode(String.self)
                    let bits = rawValue.split(separator: ",")
                    if let lat = Float(bits[0]),
                       let lon = Float(bits[1]) {
                        self = .string(lat: lat, lon: lon)
                    }
                    else {
                        self = .geoHash(rawValue)
                    }
                } catch {
                    throw ElasticsearchError(identifier: "geo_point_decode", reason: "Could not decode geo point", source: .capture())
                }
            }
        }
    }
}
