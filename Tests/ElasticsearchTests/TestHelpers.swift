import Foundation

extension JSONEncoder {
    func encodeToString<T>(_ value: T) throws -> String where T : Encodable {
        let data = try self.encode(value)
        
        return String(data: data, encoding: .utf8)!
    }
}
