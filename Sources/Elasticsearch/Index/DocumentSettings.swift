import Foundation

public struct DocumentSettings {
    public let dynamic: Bool
    public let enabled: Bool
    
    init(dynamic: Bool = false, enabled: Bool = true) {
        self.dynamic = dynamic
        self.enabled = enabled
    }
}
