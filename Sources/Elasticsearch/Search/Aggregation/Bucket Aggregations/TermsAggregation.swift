
import Foundation

public struct TermsAggregation: Aggregation {
    public static var typeKey = AggregationResponseMap.terms
    
    public var codingKey = "terms"
    public var name: String
    
    let field: String?
    let size: Int?
    let showTermDocCountError: Bool?
    let order: [String: OrderDirection]?
    let minDocCount: Int?
    let script: Script?
    let include: String?
    let exclude: String?
    let includeExact: [String]?
    let excludeExact: [String]?
    let collectMode: CollectMode?
    let executionHint: ExecutionHint?
    let missing: Int?
    
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
        field: String? = nil,
        size: Int? = nil,
        showTermDocCountError: Bool? = nil,
        order: [String: OrderDirection]? = nil,
        minDocCount: Int? = nil,
        script: Script? = nil,
        include: String? = nil,
        exclude: String? = nil,
        includeExact: [String]? = nil,
        excludeExact: [String]? = nil,
        collectMode: CollectMode? = nil,
        executionHint: ExecutionHint? = nil,
        missing: Int? = nil
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
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: codingKey)!)
        try valuesContainer.encodeIfPresent(field, forKey: .field)
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
