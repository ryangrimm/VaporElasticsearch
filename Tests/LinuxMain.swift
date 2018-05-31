import XCTest

import ElasticsearchTests

var tests = [XCTestCaseEntry]()
tests += ElasticsearchTests.allTests()
XCTMain(tests)