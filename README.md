# A Vapor/Swift Elasticsearch Client

The goal of this project is to provide a comprehensive yet easy to use
Elasticsearch client for Swift. The Vapor server side framework has a large
community around it so integrating with Vapor was a logical first step.  That
said, this library should be very easy to port to another framework (Perfect,
Kitura) or even use by itself for command line utilities and other such
purposes.

Main priorities are to provide index management (field mapping, settings,
tokenizers and analyzers), CRUD support and search results with support for
aggregations. Currently these goals are all being met on some level.

## High Level Features

* Support for creating, updating, requesting and deletion of documents
* High level construction of the Elasticsearch Query DSL
* Execution of constructed search queries
* Execution of many types of aggregations (more are implemented regurally)
* Population of object models when fetching a document and search results (via Swift Codable support)
* Automatic seralization of object models to Elasticsearch (via Swift Codable support)
* Ability to specify the mapping for index creation


## Issues/Questions

* Every document has an id and frequently that id is exposed via an API. Sometimes
  this id is computed externally from ES, sometimes the internally generated
  ids are used. Currently the Codable setup knows nothing of ids and since they
  are held outside of the document source there is not automatic solution for
  having the ids populated in the model struct/class. Therefore, from search
  results it's currently a real pain to get the ids into the models.

## TODO

* Create a chainable query builder
* Support configuration of tokenizers and analyzers
* Implement the decoding of aggregation responses
* Implement the remaining aggregation types
* Implement remaining query DSL constructors
	These are the remaining query DSL constructors that are left to be
	implemented. They are not all of equal value. But pick off those that seem
	useful/easy first.

	* [Query string](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html)
	* [Simple query string](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-simple-query-string-query.html)
	* [Terms set](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-terms-set-query.html)
	* [Span multi-term query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-multi-term-query.html)
	* [Span near query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-near-query.html)
	* [Span or query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-or-query.html)
	* [Span not query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-not-query.html)
	* [Span containing query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-containing-query.html)
	* [Span within query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-within-query.html)
	* [Span field masking query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-field-masking-query.html)
	* [Function score query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.htmlo)
	* [Boosting query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-boosting-query.html)
	* [Constant score query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-constant-score-query.html)
	* [Nested query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-nested-query.html)
	* [Has child query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-has-child-query.html)
	* [Has parent query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-has-parent-query.html)
	* [Parent ID query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-parent-id-query.html)
	* [Geo shape query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-geo-shape-query.html)
	* [Geo bounding box](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-geo-bounding-box-query.html)
	* [Geo distance](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-geo-distance-query.html)
	* [Geo polygon](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-geo-polygon-query.html)
	* [More like this query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-mlt-query.html)
	* [Percolate query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-percolate-query.html)

* Documentation 
* More unit tests
	* Need tests for encoding/decoding round trips of the Map types
* Resolve existing XXX's
* Lots more can be done
