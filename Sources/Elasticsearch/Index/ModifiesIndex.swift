
public protocol ModifiesIndex {
    func modifyBeforeSending(index: ElasticsearchIndex)
}
