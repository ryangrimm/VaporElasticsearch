//
//  ScoreFunction.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//

import Foundation

/// :nodoc:
public protocol ScoreFunctionElement: Codable {
    static var typeKey: ScoreFunctionMap { get }
}

public struct ScoreFunction: Codable {
    public let function: ScoreFunctionElement
    
    enum CodingKeys: String, CodingKey {
        case function
    }
    
    public init(_ function: ScoreFunctionElement) {
        self.function = function
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        
        try container.encode(AnyScoreFunctionElement(function), forKey: DynamicKey(stringValue: type(of: function).typeKey.rawValue)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        let type = ScoreFunctionMap(rawValue: key!.stringValue)!
        let innerDecoder = try container.superDecoder(forKey: key!)
        self.function = try type.metatype.init(from: innerDecoder)
    }
}

