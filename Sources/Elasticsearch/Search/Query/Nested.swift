//
//  Nested.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

/**
 Filters documents that have fields that match any of the provided terms (not analyzed).
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-nested-query.html)
 */
public struct Nested: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.nested
    
    public let path: String
    public let scoreMode: String?
    public let query: QueryElement
    
    public init(path: String, scoreMode: String?, query: QueryElement) {
        self.path = path
        self.scoreMode = scoreMode
        self.query = query
    }
    
    private enum CodingKeys: String, CodingKey {
        case path
        case query
        case scoreMode = "score_mode"
        
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(path, forKey: .path)
        try container.encodeIfPresent(scoreMode, forKey: .scoreMode)
        //  Encode the query
        var queryContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .query)
        try queryContainer.encode(AnyQueryElement(query), forKey: DynamicKey(stringValue: type(of: query).typeKey.rawValue)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.path = try container.decode(String.self, forKey: .path)
        self.scoreMode = try container.decodeIfPresent(String.self, forKey: .scoreMode)
        self.query = try container.decode(AnyQueryElement.self, forKey: .query).base
    }
}
