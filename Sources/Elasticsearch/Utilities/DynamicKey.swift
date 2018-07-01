struct DynamicKey: CodingKey {
    var intValue: Int? { return nil }
    var stringValue: String
    
    init?(intValue: Int) { return nil }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
}
