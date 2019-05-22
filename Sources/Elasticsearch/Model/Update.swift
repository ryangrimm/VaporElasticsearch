public struct UpdateDoc<T: Encodable> : Encodable {
    public let doc: T
    public let docAsUpsert: Bool

    public enum CodingKeys: String, CodingKey {
        case doc = "doc"
        case docAsUpsert = "doc_as_upsert"
    }
}

public struct UpdateScript : Encodable {
    public let script: Script

    public enum CodingKeys: String, CodingKey {
        case script = "script"
    }
}
