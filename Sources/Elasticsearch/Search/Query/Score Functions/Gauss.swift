//
//  Gauss.swift
//  Async
//
//  Created by Kelly Bennett on 1/4/19.
//
//[More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html))

import Foundation

public struct Gauss: ScoreFunctionElement {
    public static var typeKey = ScoreFunctionMap.gauss
    let field: String
    let origin: String
    let offset: String
    let decay: Decimal
    let scale: String
    
    public init(field: String, origin: String, offset: String, decay: Decimal, scale: String) {
        self.field = field
        self.origin = origin
        self.offset = offset
        self.decay = decay
        self.scale = scale
    }
    
    private struct Inner: Codable {
        let origin: String
        let offset: String
        let decay: Decimal
        let scale: String
        
        enum CodingKeys: String, CodingKey {
            case origin
            case offset
            case decay
            case scale
        }
      
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(origin, forKey: .origin)
            try container.encode(offset, forKey: .offset)
            try container.encode(decay, forKey: .decay)
            try container.encode(scale, forKey: .scale)
        }
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case field
        case origin
        case offset
        case decay
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Gauss.Inner(origin: origin,
                                offset: offset,
                                decay: decay,
                                scale: scale)
        try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Gauss.Inner(from: innerDecoder)
        self.origin = inner.origin
        self.offset = inner.offset
        self.decay = inner.decay
        self.scale = inner.scale
    }
}
