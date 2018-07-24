# A Vapor/Swift Elasticsearch Client 🔎
The goal of this project is to provide a comprehensive yet easy to use
Elasticsearch client for Swift. The Vapor server side framework has a large
community around it so integrating with Vapor was a logical first step.  That
said, this library should be very easy to port to another framework (Perfect,
Kitura) or even use by itself for command line utilities and other such
purposes.

Main priorities are to provide index management (field mapping, settings,
tokenizers and analyzers), CRUD support and search results with support for
aggregations. Currently these goals are all being met on some level.

### Warning
This project is under heavy development and the public API has been changing
(with no backward compatability) every week. That said, the changes tend to be
fairly minor as long as you're diligent with pulling the latest code every week.

## High Level Features

* Support for creating, updating, requesting and deletion of documents
* High level construction of the Elasticsearch Query DSL
* Execution of constructed search queries
* Execution of many types of aggregations (more are implemented regurally)
* Population of object models when fetching a document and search results (via Swift Codable support)
* Automatic seralization of object models to Elasticsearch (via Swift Codable support)
* Ability to specify the mapping for index creation
* Support for bulk operations

## 📦 Installation

### Package.swift
Add `Elasticsearch` to the Package dependencies:
```swift
dependencies: [
    ...,
    .package(url: "https://github.com/ryangrimm/VaporElasticsearch", .branch("master"))
]
```

as well as to your target (e.g. "App"):

```swift
targets: [
    ...
    .target(
        name: "App",
        dependencies: [... "Elasticsearch" ...]
    ),
    ...
]
```

## Getting started 🚀
Make sure that you've imported `Elasticsearch` everywhere needed:

```swift
import Elasticsearch
```

### Adding the Service
Add the `ElasticsearchDatabase` in your `configure.swift` file:

```swift
let esConfig = ElasticsearchClientConfig(hostname: "localhost", port: 9200)
let es = try ElasticsearchDatabase(config: esConfig)
var databases = DatabasesConfig()
databases.add(database: es, as: .elasticsearch)
services.register(databases)
```

#### Enable Logging
```swift
var databases = DatabasesConfig()
databases.enableLogging(on: .elasticsearch)
services.register(databases)
```

### Simple search example
```swift
struct Document: Codable {

    var id: String
    var title: String
}

func list(_ req: Request) throws -> Future<[Document]> {

	let query = Query(
	    Match(field: "id", value: "42")
	)

	return req.withNewConnection(to: .elasticsearch) { conn in

	    return try conn.search(
		decodeTo: Document.self,
		index: "documents",
		query: SearchContainer(query)
	    )

	}.map(to: [Document].self ) { searchResponse in

	    guard let hits = searchResponse.hits else { return [Document]() }
	    let results = hits.hits.map { $0.source }
	    return results
	}
}
```

### Creating an index (with filter)
```swift

//let client: ElasticsearchClient = ...

let synonymFilter = SynonymFilter(name: "synonym_filter",
	synonyms: ["file, document", "nice, awesome, great"])

let synonymAnalyzer = CustomAnalyzer(
	name: "synonym_analyzer",
	tokenizer: StandardTokenizer(),
	filter: [synonymFilter]))

let index = client.configureIndex(name: "documents")
	.indexSettings(index: IndexSettings(shards: 5, replicas: 1))
	.property(key: "id", type: MapKeyword())
	.property(key: "title", type: MapText(analyzer: synonymAnalyzer))

try index.create()
```

### Deleting an index
```swift

//let client: ElasticsearchClient = ...
try client.deleteIndex(name: "documents")
```

### Use `bulk`to insert documents
```swift
//let client: ElasticsearchClient = ...

let doc1 = Document(id: 1, title: "hello world")
let doc2 = Document(id: 5, title: "awesome place")

let bulk = client.bulkOperation()
bulk.defaultHeader.index = "documents"

try bulk.create(doc: doc1, id: String(doc1.id))
try bulk.create(doc: doc2, id: String(doc2.id))
// if you want to overwrite documents, use `bulk.index` instead

try bulk.send()
```
