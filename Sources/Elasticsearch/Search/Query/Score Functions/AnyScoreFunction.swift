//
//  AnyScoreFunction.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation
/// :nodoc:
public enum ScoreFunctionMap : String, Codable {
    
    case scriptScore = "script_score"
    case weight
    case randomScore = "random_score"
    case fieldValueFactor = "field_value_factor"
    case gauss
    case linear
    case exp
    
    var metatype: ScoreFunctionElement.Type {
        switch self {
        case .scriptScore:
            return ScriptScore.self
        case .weight:
            return WeightScore.self
        case .randomScore:
            return RandomScore.self
        case .fieldValueFactor:
            return FieldValueFactor.self
        case .gauss:
            return Gauss.self
        case .linear:
            return Linear.self
        case .exp:
            return Exp.self
        }
    }
}

internal struct AnyScoreFunctionElement : Codable {
    public var base: ScoreFunctionElement
    
    init(_ base: ScoreFunctionElement) {
        self.base = base
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        let type = ScoreFunctionMap(rawValue: key!.stringValue)!
        let innerDecoder = try container.superDecoder(forKey: key!)
        self.base = try type.metatype.init(from: innerDecoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

