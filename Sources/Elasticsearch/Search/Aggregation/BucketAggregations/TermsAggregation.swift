
import Foundation

/**
 A multi-bucket value source based aggregation where buckets are dynamically built - one per unique value.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html)
*/
public struct TermsAggregation: Aggregation {
  
    /// :nodoc:
    public static var typeKey = AggregationResponseMap.terms
    
    /// :nodoc:
    public var name: String
    /// :nodoc:
    public let field: String
    /// :nodoc:
    public let size: Int?
    /// :nodoc:
    public let showTermDocCountError: Bool?
    /// :nodoc:
    public let order: [String: SortOrder]?
    /// :nodoc:
    public let minDocCount: Int?
    /// :nodoc:
    public let script: Script?
    /// :nodoc:
    public let include: String?
    /// :nodoc:
    public let exclude: String?
    /// :nodoc:
    public let includeExact: [String]?
    /// :nodoc:
    public let excludeExact: [String]?
    /// :nodoc:
    public let collectMode: CollectMode?
    /// :nodoc:
    public let executionHint: ExecutionHint?
    /// :nodoc:
    public let missing: Int?
    /// :nodoc:
    public var aggs: [Aggregation]?
  
    enum CodingKeys: String, CodingKey {
        case field
        case size
        case showTermDocCountError = "show_term_doc_count_error"
        case order
        case minDocCount = "min_doc_count"
        case script
        case include
        case exclude
        case collectMode = "collect_mode"
        case executionHint = "execution_hint"
        case missing
        case aggs
    }
    
    /// Creates a [terms](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - field: The field to perform the aggregation over
    ///   - size: Defines how many term buckets should be returned out of the overall terms list
    ///   - showTermDocCountError: Include/exclude the term doc count error in the results
    ///   - order: The order of the buckets can be customized by setting the order parameter. By default, the buckets are ordered by their doc_count descending.
    ///   - minDocCount: Only return terms that match more than a configured number of hits
    ///   - script: Generate the terms using a script
    ///   - include: A regular expression string to determin which field values to include
    ///   - exclude:  A regular expression string to determin which field values to exclude
    ///   - includeExact: Ensure that the given strings exactly match the field
    ///   - excludeExact: Ensure that the specified field does not match the given strings
    ///   - collectMode: Control how terms are collected
    ///   - executionHint: Provide a hint on how terms should be collected
    ///   - missing: Defines how documents that are missing a value should be treated
    public init(
        name: String,
        field: String,
        size: Int? = nil,
        showTermDocCountError: Bool? = nil,
        order: [String: SortOrder]? = nil,
        minDocCount: Int? = nil,
        script: Script? = nil,
        include: String? = nil,
        exclude: String? = nil,
        includeExact: [String]? = nil,
        excludeExact: [String]? = nil,
        collectMode: CollectMode? = nil,
        executionHint: ExecutionHint? = nil,
        missing: Int? = nil,
        aggs: [Aggregation]? = nil
        ) {
        self.name = name
        self.field = field
        self.size = size
        self.showTermDocCountError = showTermDocCountError
        self.order = order
        self.minDocCount = minDocCount
        self.script = script
        self.include = include
        self.exclude = exclude
        self.includeExact = includeExact
        self.excludeExact = excludeExact
        self.collectMode = collectMode
        self.executionHint = executionHint
        self.missing = missing
        self.aggs = aggs
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: type(of: self).typeKey.rawValue)!)
        try valuesContainer.encode(field, forKey: .field)
        try valuesContainer.encodeIfPresent(size, forKey: .size)
        try valuesContainer.encodeIfPresent(showTermDocCountError, forKey: .showTermDocCountError)
        try valuesContainer.encodeIfPresent(minDocCount, forKey: .minDocCount)
        try valuesContainer.encodeIfPresent(script, forKey: .script)
        if includeExact != nil {
            try valuesContainer.encodeIfPresent(includeExact, forKey: .include)
        }
        else {
            try valuesContainer.encodeIfPresent(include, forKey: .include)
        }
        if excludeExact != nil {
            try valuesContainer.encodeIfPresent(excludeExact, forKey: .exclude)
        }
        else {
            try valuesContainer.encodeIfPresent(exclude, forKey: .exclude)
        }
        try valuesContainer.encodeIfPresent(collectMode, forKey: .collectMode)
        try valuesContainer.encodeIfPresent(executionHint, forKey: .executionHint)
        try valuesContainer.encodeIfPresent(missing, forKey: .missing)
        if aggs != nil && aggs!.count > 0 {
          var aggContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: DynamicKey(stringValue: "aggs")!)
          for agg in aggs! {
            try aggContainer.encode(AnyAggregation(agg), forKey: DynamicKey(stringValue: agg.name)!)
          }
        }
    }
    
    public enum CollectMode: String, Encodable {
        case breadthFirst = "breadth_first"
        case depthFirst = "depth_first"
    }
    
    public enum ExecutionHint: String, Encodable {
        case map
        case globalOrdinals = "global_ordinals"
    }
}
