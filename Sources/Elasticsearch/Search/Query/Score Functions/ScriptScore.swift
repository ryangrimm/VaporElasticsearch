//
//  ScoreFunction.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

public struct ScriptScore: ScoreFunctionElement {
    public static var typeKey = ScoreFunctionMap.scriptScore
    
    public let script: Script
    
    public init(script: Script) {
        self.script = script
    }
    
    enum CodingKeys: String, CodingKey {
        case script
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(script, forKey: .script)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.script = try container.decode(Script.self, forKey: .script)
    }
}
