
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
}
