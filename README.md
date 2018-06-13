# Elasticsearch

## Issues/Questions

* It's very common for someone to have an "id" for each document. Sometimes
  this id is computed externally from ES, sometimes the internally generated
  ids are used. Currently the Codable setup knows nothing of ids and since they
  are held outside of the document source there is not automatic solution for
  having the ids populated in the model struct/class. Therefore, from search
  results it's currently a real pain to get the ids into the models.

## TODO

* Implement the decoding of aggregation responses
* Implement the remaining aggregation types
* Implement remaining query DSL constructors
	These are the remaining query DSL constructors that are left to be
	implemented. They are not all of equal value. But pick off those that seem
	useful/easy first.

	* [Match phrase](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query-phrase-prefix.html)
	* [Common terms](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-common-terms-query.html)
	* [Query string](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html)
	* [Simple query string](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-simple-query-string-query.html)
	* [Terms set](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-terms-set-query.html)
	* [Span term query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-term-query.html)
	* [Span multi-term query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-multi-term-query.html)
	* [Span first query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-span-first-query.html)
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
	* [Script query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-script-query.html)

* Convert the Range and Bool query DSL consructors to being Codable instead of just Encodable
* Documentation 
* More unit tests
	* Need tests for encoding/decoding round trips of the ES types
* Resolve existing XXX's
* Lots more can be done
