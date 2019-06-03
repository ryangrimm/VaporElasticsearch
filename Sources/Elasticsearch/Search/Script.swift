
/**
 Many aggregations and some queries allow for the configuration of a script.
 Scripts can be provided inline via the source parameter or be stored on the
 server and referenced via the id parameter.
 */
public struct Script: Codable {
    public let lang: String?
    public let source: String?
    public let id: String?
    public let params: [String: Any]?

    enum CodingKeys: String, CodingKey {
        case lang
        case source
        case id
        case params
    }

    /// Configure a script for execution
    ///
    /// - Parameters:
    ///   - lang: Language that the script is written in
    ///   - source: Source of the script
    ///   - id: The identifier for a stored script
    ///   - params: Parameters to pass to the script
    public init(
        lang: String? = nil,
        source: String? = nil,
        id: String? = nil,
        params: [String: Any]? = nil
        ) {
        self.lang = lang
        self.source = source
        self.id = id
        self.params = params
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(lang, forKey: .lang)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(id, forKey: .id)

        if params != nil && params!.count > 0 {
            var keyedContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .params)
            for (name, value) in params! {
                switch value {
                case is Int:
                    try keyedContainer.encode(value as! Int, forKey: DynamicKey(stringValue: name)!)
                case is Int8:
                    try keyedContainer.encode(value as! Int8, forKey: DynamicKey(stringValue: name)!)
                case is Int16:
                    try keyedContainer.encode(value as! Int16, forKey: DynamicKey(stringValue: name)!)
                case is Int32:
                    try keyedContainer.encode(value as! Int32, forKey: DynamicKey(stringValue: name)!)
                case is Int64:
                    try keyedContainer.encode(value as! Int64, forKey: DynamicKey(stringValue: name)!)
                case is Float:
                    try keyedContainer.encode(value as! Float, forKey: DynamicKey(stringValue: name)!)
                case is Double:
                    try keyedContainer.encode(value as! Double, forKey: DynamicKey(stringValue: name)!)
                case is Bool:
                    try keyedContainer.encode(value as! Bool, forKey: DynamicKey(stringValue: name)!)
                case is String:
                    try keyedContainer.encode(value as! String, forKey: DynamicKey(stringValue: name)!)
                case is [String]:
                    try keyedContainer.encode(value as! [String], forKey: DynamicKey(stringValue: name)!)
                default:
                    continue
                }
            }
        }
    }

    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lang = try container.decodeIfPresent(String.self, forKey: .lang)
        self.source = try container.decodeIfPresent(String.self, forKey: .source)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)

        if container.contains(.params) {
            let paramsContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .params)
            if paramsContainer.allKeys.count > 0 {
                var params = [String: Any]()
                for key in paramsContainer.allKeys {
                    if let value = try? paramsContainer.decode(Bool.self, forKey: key) {
                        params[key.stringValue] = value
                    }
                    if let value = try? paramsContainer.decode(Int64.self, forKey: key) {
                        params[key.stringValue] = value
                    }
                    if let value = try? paramsContainer.decode(Double.self, forKey: key) {
                        params[key.stringValue] = value
                    }
                    if let value = try? paramsContainer.decode(String.self, forKey: key) {
                        params[key.stringValue] = value
                    }
                }
                self.params = params
            }
            else {
                self.params = nil
            }
        }
        else {
            self.params = nil
        }

    }
}
