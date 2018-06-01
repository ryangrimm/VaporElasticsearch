//
//  ElasticsearchError.swift
//  Elasticsearch
//
//  Created by Ryan Grimm on 5/31/18.
//

import Debugging
import COperatingSystem

/// Errors that can be thrown while working with Elasticsearch.
public struct ElasticsearchError: Debuggable {
    public static let readableName = "Elasticsearch Error"
    public let identifier: String
    public var reason: String
    public var sourceLocation: SourceLocation?
    public var stackTrace: [String]
    public var possibleCauses: [String]
    public var suggestedFixes: [String]
    
    /// Create a new Elasticsearch error.
    public init(
        identifier: String,
        reason: String,
        possibleCauses: [String] = [],
        suggestedFixes: [String] = [],
        source: SourceLocation
        ) {
        self.identifier = identifier
        self.reason = reason
        self.sourceLocation = source
        self.stackTrace = ElasticsearchError.makeStackTrace()
        self.possibleCauses = possibleCauses
        self.suggestedFixes = suggestedFixes
    }
}

func VERBOSE(_ string: @autoclosure () -> (String)) {
    #if VERBOSE
    print("[VERBOSE] [Elasticsearch] \(string())")
    #endif
}
