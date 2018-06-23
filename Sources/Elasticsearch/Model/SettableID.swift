import Foundation

/**
 When fetching a document either by id or via a search query,
 the model that is populated with the data can implement this
 method to have the id for the document set.
 
 This is necessary due to the fact that Elasticsearch stores
 the id for a document outside of the document itself.
 */
public protocol SettableID {
    /// Called when the model object is created via fetching by id or via a search result.
    ///
    /// - Parameter id: The id of the document that can then be set to whatever the id property is.
    mutating func setID(_ id: String)
}
