import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ElasticsearchTests.allTests),
        testCase(ElasticsearchSearchEncodingTests.allTests)
    ]
}
#endif
