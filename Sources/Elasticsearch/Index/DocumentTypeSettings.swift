import Foundation

struct DocumentTypeSettings: Codable {
    var properties = [String: Mappable]()
    var enabled = true
    var dynamic = false
    var meta: IndexMeta?
    
    enum CodingKeys: String, CodingKey {
        case properties
        case enabled
        case dynamic
        case meta = "_meta"
    }
    
    init() {
        self.meta = IndexMeta()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if decoder.getAnalysis() == nil {
            return
        }
        
        self.properties = try container.decode([String: AnyMap].self, forKey: .properties).mapValues { $0.base }
        self.meta = try? container.decode(IndexMeta.self, forKey: .meta)
        
        if container.contains(.enabled) {
            do {
                self.enabled = (try container.decode(Bool.self, forKey: .enabled))
            }
            catch {
                self.enabled = try container.decode(String.self, forKey: .enabled) == "true"
            }
        }
        if container.contains(.dynamic) {
            do {
                self.dynamic = (try container.decode(Bool.self, forKey: .dynamic))
            }
            catch {
                self.dynamic = try container.decode(String.self, forKey: .dynamic) == "true"
            }
        }
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
                
        try container.encode(properties.mapValues { AnyMap($0) }, forKey: .properties)
        try container.encodeIfPresent(dynamic, forKey: .dynamic)
        try container.encodeIfPresent(enabled, forKey: .enabled)
        try container.encodeIfPresent(meta, forKey: .meta)
    }
}
