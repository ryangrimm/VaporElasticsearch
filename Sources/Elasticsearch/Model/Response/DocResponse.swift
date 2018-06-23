
public struct DocResponse<T: Codable>: Codable {
    let index :String
    let type :String
    let id :String
    let version :Int
    var source :T
    var routing :String? = nil
    
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
