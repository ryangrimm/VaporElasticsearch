# Elasticsearch

## Issues/Questions

* It's very common for someone to have an "id" for each document. Sometimes
  this id is computed externally from ES, sometimes the internally generated
  ids are used. Currently the Codable setup knows nothing of ids and since they
  are held outside of the document source there is not automatic solution for
  having the ids populated in the model struct/class. Therefore, from search
  results it's currently a real pain to get the ids into the models.

## TODO

* Add support for aggregations
* Implement remaining ES types
* Implement remaining query DSL constructors
* Documentation 
* More unit tests
* Resolve existing XXX's
* Lots more can be done
