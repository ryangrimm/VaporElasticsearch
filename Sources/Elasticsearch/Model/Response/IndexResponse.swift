public struct IndexResponse: Codable {
    let shards :Shards
    let index :String
    let type :String
    let id :String
    let version :Int
    let result :ResultType
    let seqNo: Int
    let primaryTerm: Int
    var routing :String?
    
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
        case seqNo = "_seq_no"
        case primaryTerm = "_primary_term"
    }
}
