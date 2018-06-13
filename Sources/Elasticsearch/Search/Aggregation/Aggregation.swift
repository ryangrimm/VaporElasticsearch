
import Foundation

public protocol Aggregation: Encodable {
    static var typeKey: AggregationMap { get }
    
    var codingKey: String { get set }
    var name: String { get set }
}

public enum OrderDirection: String, Encodable {
    case asc
    case desc
}

public struct AggregationScript: Encodable {
    let lang: String?
    let source: String?
    let id: String?
    let params: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case lang
        case source
        case id
        case params
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(lang, forKey: .lang)
        try container.encode(source, forKey: .source)
        try container.encode(id, forKey: .id)
        
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
                default:
                    continue
                }
            }
        }
    }
}
