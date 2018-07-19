
import Foundation

public struct Analysis: Codable {
    
    public struct Analyzer: Codable {
        public var tokenizer: String
        public var filter: [String]?
        
        public init(filter: [String]? = [], tokenizer: String) {
            self.filter = filter
            self.tokenizer = tokenizer
        }
    }
    
    public struct Filter: Codable {
        public let type: String
        public var name: String?
        public var synonyms: [String]?
        
        public init(type: String, name: String? = nil, synonyms: [String]? = nil) {
            self.type = type
            self.name = name
            self.synonyms = synonyms
        }
    }
    
    public struct Normalizer: Codable {
        public var filter: [String]?
        
        public init(filter: [String]? = []) {
            self.filter = filter
        }
    }
    
    public var filter: [String: Filter]?
    public var analyzer: [String: Analyzer]?
    public var normalizer: [String: Normalizer]?
    
    public init(
        filter: [String: Filter]? = nil,
        analyzer: [String: Analyzer]? = nil,
        normalizer: [String: Normalizer]? = nil) {
        
        self.filter = filter
        self.analyzer = analyzer
        self.normalizer = normalizer
    }
}
