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
    
    /// Returns categories matching the given IDs.
    /// - Parameter ids: IDs to filter by.
    /// - Returns: Categories with matching IDs.
    func getCategories(of ids: [Int]) -> [Category] {
        categories.filter { ids.contains($0.id) }
    }
    
    /// Returns the category with the specified ID.
    /// - Parameter id: The category's ID.
    /// - Returns: A matching category, or nil.
    func getCategory(of id: Int) -> Category? {
        categories.first { $0.id == id }
    }
    
    /// Returns questions matching the given IDs.
    /// - Parameter ids: IDs to filter by.
    /// - Returns: Questions with matching IDs.
    func getQuestions(of ids: [Int]) -> [Question] {
        questions.filter { ids.contains($0.id) }
    }
    
    /// Returns the question with the specified ID.
    /// - Parameter id: The question's ID.
    /// - Returns: A matching question, or nil.
    func getQuestion(of id: Int) -> Question? {
        questions.first { $0.id == id }
    }
}
