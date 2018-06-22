import Foundation

public struct ScriptQuery: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.script
    
    /// :nodoc:
    public var codingKey = "script"
    
    let script: Script
    
    enum CodingKeys: String, CodingKey {
        case script
    }
    
    public init(script: Script) {
        self.script = script
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(script, forKey: .script)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.script = try container.decode(Script.self, forKey: .script)
    }
}