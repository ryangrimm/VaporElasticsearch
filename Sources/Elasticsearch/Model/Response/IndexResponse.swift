public struct IndexResponse: Codable {
    public let shards :Shards
    public let index :String
    public let type :String
    public let id :String
    public let version :Int
    public let result :ResultType
    public let seqNo: Int? = nil
    public let primaryTerm: Int? = nil
//    public let routing :String?

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
