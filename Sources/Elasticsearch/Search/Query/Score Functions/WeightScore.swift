//
//  Weight.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

public struct WeightScore: ScoreFunctionElement {
    public static var typeKey = ScoreFunctionMap.weight
    
    public let weight: Decimal
    
    public init(weight: Decimal) {
        self.weight = weight
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {}
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        //TODO: get from decoder
        self.weight = 1
    }
}

