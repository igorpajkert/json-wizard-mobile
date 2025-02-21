//
//  DataStore.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import Foundation
import FirebaseFirestore

/// A data store that manages categories and questions.
@Observable
final class DataStore {
    
    let database = DatabaseController()
    
    var categories: [Category]
    var questions: [Question]
    
    var currentCollectionType = CollectionType.development
    var currentCollection = (
        categories: Collection.devCategories,
        questions: Collection.devQuestions
    )
    
    var categoriesListener: ListenerRegistration? = nil
    var questionsListener: ListenerRegistration? = nil
    
    init(
        categories: [Category] = [Category](),
        questions: [Question] = [Question]()
    ) {
        self.categories = categories
        self.questions = questions
        
        fetchData(for: currentCollectionType)
        attachListeners(to: currentCollectionType)
    }
    
    deinit {
        detachListeners()
    }
    
    /// Retrieves an array of `Category` objects that match the specified indices.
    ///
    /// - Parameter indices: An array of integer IDs to filter categories.
    /// - Returns: An array of `Category` objects whose IDs match the given indices.
    func getCategories(of indices: [Int]) -> [Category] {
        categories.filter { indices.contains($0.id) }
    }
    
    /// Retrieves an array of `Question` objects that match the specified indices.
    ///
    /// - Parameter indices: An array of integer IDs to filter questions.
    /// - Returns: An array of `Question` objects whose IDs match the given indices.
    func getQuestions(of indices: [Int]) -> [Question] {
        questions.filter { indices.contains($0.id) }
    }
}
