
public struct DocResponse<T: Decodable>: Decodable {
    public let index :String
    public let type :String
    public let id :String
    public let version :Int
    public var source :T
    public var routing :String? = nil
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case source = "_source"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(String.self, forKey: .index)
        self.type = try container.decode(String.self, forKey: .type)
        self.id = try container.decode(String.self, forKey: .id)
        self.version = try container.decode(Int.self, forKey: .version)
        var source = try container.decode(T.self, forKey: .source)
        if var settableIDSource = source as? SettableID {
            settableIDSource.setID(self.id)
            source = settableIDSource as! T
        }
        
        self.source = source
    }
}
