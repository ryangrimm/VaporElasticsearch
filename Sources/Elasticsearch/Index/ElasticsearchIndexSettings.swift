import Foundation

public struct ElasticsearchIndexSettings: Codable {
    public var index: IndexSettings? = nil
    public var analysis = Analysis()
    
    init(index: IndexSettings? = nil) {
        self.index = index
    }
    
    enum CodingKeys: String, CodingKey {
        case index
        case analysis
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(index, forKey: .index)
        if analysis.isEmpty() == false {
            try container.encode(analysis, forKey: .analysis)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decodeIfPresent(IndexSettings.self, forKey: .index)
        
        let analysisContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .index)
        if let analysis = try analysisContainer.decodeIfPresent(Analysis.self, forKey: DynamicKey(stringValue: "analysis")!) {
            self.analysis = analysis
        }
        else {
            self.analysis = Analysis()
        }
    }
}

public struct ElasticsearchIndexType: Codable {
    public var doc: DocumentTypeSettings
    
    public let type = "_doc"
    
    enum CodingKeys: String, CodingKey {
        case doc = "_doc"
    }
}

public struct ElasticsearchIndexAlias: Codable {
    var routing: String?
}
