
import Foundation

/**
 A token filter of type porter_stem that transforms the token stream as per the Porter stemming algorithm.
 
 Note, the input to the stemming filter must already be in lower case, so you will need to use Lower Case Token Filter or Lower Case Tokenizer farther down the Tokenizer chain in order for this to work properly!. For example, when using custom analyzer, make sure the lowercase filter comes before the porter_stem filter in the list of filters.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-porterstem-tokenfilter.html)
 */
public struct PorterStemFilter: BasicTokenFilter, BuiltinTokenFilter {
    /// :nodoc:
    public static var typeKey = TokenFilterType.porterStem
    
    public let type = typeKey.rawValue
    /// :nodoc:
    public let name: String
    
    public init() {
        self.name = self.type
    }
}
