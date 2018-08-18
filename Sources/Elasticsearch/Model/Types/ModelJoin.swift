
import Foundation

public struct ModelJoin: ModelType {
    // NOTE: Implement
}

extension ModelJoin {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.join
        public var relations = [String: String]()
        
        enum CodingKeys: String, CodingKey {
            case type
            case relations
        }
        
        public init() { }
        
        public init(relations: [String: String]) {
            self.relations = relations
        }
    }
}
