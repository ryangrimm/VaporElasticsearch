//
//  FieldValueFactor.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

public struct FieldValueFactor: ScoreFunctionElement {
    public static var typeKey = ScoreFunctionMap.fieldValueFactor
    
    public let field: String
    public let factor: Decimal
    public let modifier: String
    public let missing: Decimal
    
    public init(field: String, factor: Decimal, modifier: String, missing: Decimal) {
        self.field = field
        self.factor = factor
        self.modifier = modifier
        self.missing = missing
    }
    
    enum CodingKeys: String, CodingKey {
        case field
        case factor
        case modifier
        case missing
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field, forKey: .field)
        try container.encode(factor, forKey: .factor)
        try container.encode(modifier, forKey: .modifier)
        try container.encode(missing, forKey: .missing)
    }
   
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.field = try container.decode(String.self, forKey: .field)
        self.factor = try container.decode(Decimal.self, forKey: .factor)
        self.modifier = try container.decode(String.self, forKey: .modifier)
        self.missing = try container.decode(Decimal.self, forKey: .missing)
    }
}
