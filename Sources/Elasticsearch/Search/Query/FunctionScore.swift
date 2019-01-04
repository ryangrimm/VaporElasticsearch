//
//  FunctionScoreQuery.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

/**
 The `Function Score` returns documents in "score" order, as determined by the score funtions.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html)
 */

public struct FunctionScore: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.functionScore
    
    public let query: QueryElement
    public let boost: Decimal?
    public let functions: [ScoreFunctionElement]
    public let maxBoost: Decimal?
    public let scoreMode: String?
    public let boostMode: String?
    public let minScore: Decimal?
    
    public init(query: QueryElement,
                boost: Decimal? = nil,
                functions: [ScoreFunctionElement],
                maxBoost: Decimal? = nil,
                scoreMode: String? = nil,
                boostMode: String? = nil,
                minScore: Decimal? = nil) {
        self.query = query
        self.boost = boost
        self.functions = functions
        self.maxBoost = maxBoost
        self.scoreMode = scoreMode
        self.boostMode = boostMode
        self.minScore = minScore
    }
    
    private enum CodingKeys: String, CodingKey {
        case query
        case boost
        case functions
        case maxBoost = "max_boost"
        case scoreMode = "score_mode"
        case boostMode = "boost_mode"
        case minScore = "min_score"
    }
    
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(boost, forKey: .boost)
        try container.encodeIfPresent(maxBoost, forKey: .maxBoost)
        try container.encodeIfPresent(scoreMode, forKey: .scoreMode)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        //        TODO: get these from the decoder
        self.query = MatchAll()
        self.boost = nil
        self.functions = [RandomScore()]
        self.maxBoost = nil
        self.scoreMode = nil
        self.boostMode = "sum"
        self.minScore = nil
        
    }
}
