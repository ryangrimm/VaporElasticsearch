import Foundation

/// :nodoc:
public struct IndexMeta: Codable {
    var `private`: PrivateIndexMeta
    public var userDefined: [String: String]?
    
    init() {
        self.private = PrivateIndexMeta(version: 1)
    }
}

/// :nodoc:
internal struct PrivateIndexMeta: Codable {
    let serialVersion: Int
    var propertiesHash: String 
    
    init(version: Int) {
        self.serialVersion = version
       self.propertiesHash = ""
    }
}
