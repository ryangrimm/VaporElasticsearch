import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ElasticsearchTests.allTests),
        testCase(ElasticsearchQueryCodingTests.allTests),
        testCase(ElasticsearchAggregationCodingTests.allTests),
        testCase(ElasticsearchAnalysisNormalizerTests.allTests),
        testCase(ElasticsearchAnalysisTokenizerTests.allTests)
    ]
}
#endif
