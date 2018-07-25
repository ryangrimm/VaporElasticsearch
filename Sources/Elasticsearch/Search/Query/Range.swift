import Foundation

/**
 Matches documents with fields that have terms within a certain range. The type
 of the Lucene query depends on the field type, for string fields, the
 TermRangeQuery, while for number/date fields, the query is a
 NumericRangeQuery.

 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/6.3/query-dsl-range-query.html)
 */
public struct Range: QueryElement {
    /// :nodoc:
    public static var typeKey = QueryElementMap.range

    public let field: String
    public let greaterThanOrEqual: RangePair?
    public let greaterThan: RangePair?
    public let lesserThanOrEqual: RangePair?
    public let lesserThan: RangePair?
    public let boost: Decimal?
    public let format: String?
    public let timeZone: String?

    public init(
        field: String,
        greaterThanOrEqualTo: Double? = nil,
        greaterThan: Double? = nil,
        lesserThanOrEqualTo: Double? = nil,
        lesserThan: Double? = nil,
        boost: Decimal? = nil
    ) {
        self.field = field
        self.greaterThanOrEqual = RangePair(greaterThanOrEqualTo, nil)
        self.greaterThan = RangePair(greaterThan, nil)
        self.lesserThanOrEqual = RangePair(lesserThanOrEqualTo, nil)
        self.lesserThan = RangePair(lesserThan, nil)
        self.boost = boost
        self.format = nil
        self.timeZone = nil
    }

    public init(
        field: String,
        greaterThanOrEqualTo: String? = nil,
        greaterThan: String? = nil,
        lesserThanOrEqualTo: String? = nil,
        lesserThan: String? = nil,
        boost: Decimal? = nil,
        format: String? = nil,
        timeZone: String? = nil
    ) {
        self.field = field
        self.greaterThanOrEqual = RangePair(nil, greaterThanOrEqualTo)
        self.greaterThan = RangePair(nil, greaterThan)
        self.lesserThanOrEqual = RangePair(nil, lesserThanOrEqualTo)
        self.lesserThan = RangePair(nil, lesserThan)
        self.boost = boost
        self.format = format
        self.timeZone = timeZone
    }

    private struct Inner: Codable {
        let greaterThanOrEqual: RangePair?
        let greaterThan: RangePair?
        let lesserThanOrEqual: RangePair?
        let lesserThan: RangePair?
        let boost: Decimal?
        let format: String?
        let timeZone: String?

        enum CodingKeys: String, CodingKey {
            case greaterThanOrEqual = "gte"
            case greaterThan = "gt"
            case lesserThanOrEqual = "lte"
            case lesserThan = "lt"
            case boost
            case format
            case timeZone = "time_zone"
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            if let pair = greaterThanOrEqual, pair.hasValue {
                try container.encodeIfPresent(greaterThanOrEqual, forKey: .greaterThanOrEqual)
            }

            if let pair = greaterThan, pair.hasValue {
                try container.encodeIfPresent(greaterThan, forKey: .greaterThan)
            }

            if let pair = lesserThanOrEqual, pair.hasValue {
                try container.encodeIfPresent(lesserThanOrEqual, forKey: .lesserThanOrEqual)
            }

            if let pair = lesserThan, pair.hasValue {
                try container.encodeIfPresent(lesserThan, forKey: .lesserThan)
            }

            try container.encodeIfPresent(boost, forKey: .boost)
            try container.encodeIfPresent(format, forKey: .format)
            try container.encodeIfPresent(timeZone, forKey: .timeZone)
        }
    }

    public struct RangePair: Codable {
        let numeric: Double?
        let textual: String?
        var hasValue: Bool {
            get { return numeric != nil || textual != nil }
        }

        init(_ numeric: Double? = nil, _ textual: String? = nil) {
            self.numeric = numeric
            self.textual = textual
        }

        /// :nodoc:
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            if let numeric = numeric {
                try container.encode(numeric)
            } else if let textual = textual {
                try container.encode(textual)
            }
        }
        
        /// :nodoc:
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            do {
                self.numeric = try container.decode(Double.self)
                self.textual = nil
            } catch {
                self.textual = try container.decode(String.self)
                self.numeric = nil
            }
        }
    }

    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        let inner = Range.Inner(
            greaterThanOrEqual: greaterThanOrEqual,
            greaterThan: greaterThan,
            lesserThanOrEqual: lesserThanOrEqual,
            lesserThan: lesserThan,
            boost: boost,
            format: format,
            timeZone: timeZone
        )

        try container.encode(inner, forKey: DynamicKey(stringValue: field)!)
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let key = container.allKeys.first
        self.field = key!.stringValue
        
        let innerDecoder = try container.superDecoder(forKey: key!)
        let inner = try Range.Inner(from: innerDecoder)
        self.greaterThanOrEqual = inner.greaterThanOrEqual
        self.greaterThan = inner.greaterThan
        self.lesserThanOrEqual = inner.lesserThanOrEqual
        self.lesserThan = inner.lesserThan
        self.boost = inner.boost
        self.format = inner.format
        self.timeZone = inner.timeZone
    }
}
