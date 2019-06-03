//
//  Random.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

public struct RandomScore: ScoreFunctionElement {
    public static var typeKey = ScoreFunctionMap.randomScore
    
    public init() {
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {}
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {}
}
