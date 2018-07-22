
public protocol IndexModifies {
    mutating func modifyAfterReceiving(index: ElasticsearchIndex)
}
