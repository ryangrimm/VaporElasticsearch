# Contributing to the Swift Elasticsearch client

First off… awesome! All contributors are welcome!

Since this project is still fairly young, contributing is also fairly easy.
There's lots to be done by people of all skill levels. More tests can always
be written, more and better documentation can always be provided to users.

If you have time on your hands and want to find something to contribute, take
a look at the TODO file for ideas on what can be done to help out.

## Testing

Once in Xcode, select the `Vapor-Package` scheme and use `CMD+U` to run the tests.

When adding new tests, don't forget to add the method name to the `allTests` array. 
If you add a new `XCTestCase` subclass, make sure to add it to the `Tests/LinuxMain.swift` file.

If you are fixing a single GitHub issue in particular, you can add a test named `testGH<issue number>` to ensure
that your fix is working. This will also help prevent regression.
