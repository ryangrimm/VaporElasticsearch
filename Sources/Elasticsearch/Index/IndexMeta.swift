import Foundation

/// :nodoc:
internal struct IndexMeta: Codable {
    var `private`: PrivateIndexMeta
    var userDefined: [String: String]?
    
    init() {
        self.private = PrivateIndexMeta(version: 1)
    }
}

/// :nodoc:
public struct PrivateIndexMeta: Codable {
    let serialVersion: Int
    var propertiesHash: String
    
    init(version: Int) {
        self.serialVersion = version
       self.propertiesHash = ""
    }
}
