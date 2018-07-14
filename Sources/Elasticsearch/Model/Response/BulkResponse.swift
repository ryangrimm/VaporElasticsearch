    
public enum OperationType: String, Codable {
    case index
    case create
    case update
    case delete
}

public struct BulkItemResponse: Decodable {
    var operationType: OperationType? = nil
    let shards: Shards
    let index: String
    let type: String
    let id: String
    let version: Int
    let result: ResultType
    let status: Int
    let seqNo: Int
    let primaryTerm: Int
    
    public struct Shards: Codable {
        public let total: Int
        public let successful: Int
        public let failed: Int
        public let skipped: Int?
    }
    
    public enum ResultType: String, Codable {
        case created = "created"
        case updated = "updated"
        case deleted = "deleted"
        case notFound = "not_found"
        case noop = "noop"
    }
    
    enum CodingKeys: String, CodingKey {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case result
        case status
        case seqNo = "_seq_no"
        case primaryTerm = "_primary_term"
    }
}

public struct BulkResponse: Decodable {
    let took: Int
    let errors: Bool
    let items: [BulkItemResponse]
    
    enum CodingKeys: String, CodingKey {
        case took
        case errors
        case items
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.took = try container.decode(Int.self, forKey: .took)
        self.errors = try container.decode(Bool.self, forKey: .errors)
        
        var items = [BulkItemResponse]()
        var rawItems = try container.nestedUnkeyedContainer(forKey: .items)
        while (!rawItems.isAtEnd) {
            let itemContainer = try rawItems.nestedContainer(keyedBy: DynamicKey.self)
            for key in itemContainer.allKeys {
                var item = try itemContainer.decode(BulkItemResponse.self, forKey: key)
                item.operationType = OperationType(rawValue: key.stringValue)
                items.append(item)
            }
        }
        self.items = items
    }
    
    
    
}
