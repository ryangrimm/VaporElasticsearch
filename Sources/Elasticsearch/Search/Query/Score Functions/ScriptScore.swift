//
//  ScoreFunction.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

public struct ScriptScore: ScoreFunctionElement {
    public static var typeKey = ScoreFunctionMap.scriptScore
    
    public let script: String
    
    public init(script: String) {
        self.script = script
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {}
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        //TODO: get from decoder
        self.script = ""
    }
}
