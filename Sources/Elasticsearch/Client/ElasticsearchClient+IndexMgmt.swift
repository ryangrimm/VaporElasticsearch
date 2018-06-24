//
//  ElasticsearchClient+IndexMgmt.swift
//  Elasticsearch
//
//  Created by Ryan Grimm on 6/23/18.
//

extension ElasticsearchClient {
    public func fetchIndex(name: String) throws -> Future<ElasticsearchIndex> {
        return try ElasticsearchIndex.fetch(indexName: name, client: self)
    }
    
    public func createIndex(name: String) -> ElasticsearchIndex {
        return ElasticsearchIndex(indexName: name, client: self)
    }
    
    public func deleteIndex(name: String) throws -> Future<Void> {
        return try ElasticsearchIndex.delete(indexName: name, client: self)
    }
}
