
import Foundation

public struct ModelPercolator: ModelType {
    // NOTE: Implement
}

extension ModelPercolator {
    public static let backingType: Mappable.Type = Mapping.self

    public struct Mapping: Mappable {
        /// Holds the string that Elasticsearch uses to identify the mapping type
        public let type = MapType.percolator
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public init() {}
    }
}
