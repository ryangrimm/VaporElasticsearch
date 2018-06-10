import Foundation

public struct Range: QueryElement {
    public var codingKey = "range"

    let key: String
    let greaterThanOrEqual: RangePair?
    let greaterThan: RangePair?
    let lesserThanOrEqual: RangePair?
    let lesserThan: RangePair?
    let boost: Decimal?
    let format: String?
    let timeZone: String?

    public init(
        key: String,
        greaterThanOrEqualTo: Double? = nil,
        greaterThan: Double? = nil,
        lesserThanOrEqualTo: Double? = nil,
        lesserThan: Double? = nil,
        boost: Decimal? = nil
    ) {
        self.key = key
        self.greaterThanOrEqual = RangePair(greaterThanOrEqualTo, nil)
        self.greaterThan = RangePair(greaterThan, nil)
        self.lesserThanOrEqual = RangePair(lesserThanOrEqualTo, nil)
        self.lesserThan = RangePair(lesserThan, nil)
        self.boost = boost
        self.format = nil
        self.timeZone = nil
    }

    public init(
        key: String,
        greaterThanOrEqualTo: String? = nil,
        greaterThan: String? = nil,
        lesserThanOrEqualTo: String? = nil,
        lesserThan: String? = nil,
        boost: Decimal? = nil,
        format: String? = nil,
        timeZone: String? = nil
    ) {
        self.key = key
        self.greaterThanOrEqual = RangePair(nil, greaterThanOrEqualTo)
        self.greaterThan = RangePair(nil, greaterThan)
        self.lesserThanOrEqual = RangePair(nil, lesserThanOrEqualTo)
        self.lesserThan = RangePair(nil, lesserThan)
        self.boost = boost
        self.format = format
        self.timeZone = timeZone
    }

    struct Inner: Encodable {
        let greaterThanOrEqual: RangePair?
        let greaterThan: RangePair?
        let lesserThanOrEqual: RangePair?
        let lesserThan: RangePair?
        let boost: Decimal?
        let format: String?
        let timeZone: String?

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

        enum CodingKeys: String, CodingKey {
            case greaterThanOrEqual = "gte"
            case greaterThan = "gt"
            case lesserThanOrEqual = "lte"
            case lesserThan = "lt"
            case boost
            case format
            case timeZone = "time_zone"
        }
    }

    struct RangePair: Codable {
        let numeric: Double?
        let textual: String?
        var hasValue: Bool {
            get { return numeric != nil || textual != nil }
        }

        init(_ numeric: Double? = nil, _ textual: String? = nil) {
            self.numeric = numeric
            self.textual = textual
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            if let numeric = numeric {
                try container.encode(numeric)
            } else if let textual = textual {
                try container.encode(textual)
            }
        }
    }

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

        try container.encode(inner, forKey: DynamicKey(stringValue: key)!)
    }
}
