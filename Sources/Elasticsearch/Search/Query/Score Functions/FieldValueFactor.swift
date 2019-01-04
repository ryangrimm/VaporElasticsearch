//
//  FieldValueFactor.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

public struct FieldValueScore: ScoreFunctionElement {
    public static var typeKey = ScoreFunctionMap.fieldValueFactor
    
    public let field: String
    
    public init(field: String) {
        self.field = field
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {}
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        //TODO: get from decoder
        self.field = "taco"
    }
}
