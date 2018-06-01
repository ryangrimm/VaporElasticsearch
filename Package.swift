// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Elasticsearch",
    products: [
        .library(name: "Elasticsearch", targets: ["Elasticsearch"])
    ],
    dependencies: [
		// Core extensions, type-aliases, and functions that facilitate common tasks.
		.package(url: "https://github.com/vapor/core.git", from: "3.0.0"),

		// Core services for creating database integrations.
		.package(url: "https://github.com/vapor/database-kit.git", from: "1.0.0"),

		// Event-driven network application framework for high performance protocol servers & clients, non-blocking.
		.package(url: "https://github.com/apple/swift-nio.git", from: "1.0.0"),

		// Grab the HTTP goodies from Vapor
		.package(url: "https://github.com/vapor/http.git", from: "3.0.0"),
    ],
    targets: [
        .target( name: "Elasticsearch", dependencies: ["Async", "Bits", "DatabaseKit", "Debugging", "NIO", "COperatingSystem", "HTTP"]),
        .testTarget( name: "ElasticsearchTests", dependencies: ["Elasticsearch"])
    ]
)
