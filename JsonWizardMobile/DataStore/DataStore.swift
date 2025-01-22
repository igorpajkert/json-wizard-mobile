//
//  DataStore.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import SwiftUI

/// A data store that manages categories and questions.
@Observable
class DataStore {
    
    /// Holds a list of `Category` objects (read-only externally).
    private(set) var categoriesObject: Categories
    /// Holds a list of `Question` objects (read-only externally).
    private(set) var questionsObject: Questions
    
    /// Tracks whether categories and questions are initially loaded.
    private var isInitiallyLoaded = (categories: false, questions: false)
    
    /// Calculates and returns the next category's unique ID.
    var nextCategoryId : Int { categoriesObject.categories.maxId + 1 }
    /// Calculates and returns the next question's unique ID.
    var nextQuestionId : Int { questionsObject.questions.maxId + 1 }
    
    init(categoriesObject: Categories = Categories(),
         questionsObject: Questions = Questions()) {
        self.categoriesObject = categoriesObject
        self.questionsObject = questionsObject
    }
    
    /// Creates and returns a new category with a unique identifier.
    ///
    /// This function calls `nextCategoryId()` to generate a unique ID for the `Category`.
    /// You can safely use this function to initialize an empty or default `Category` object
    /// for further customization.
    ///
    /// - Returns: A newly created `Category` object with a unique identifier.
    func createEmptyCategory() -> Category {
        Category(id: nextCategoryId)
    }
    
    /// Creates and returns a new question with a unique identifier, optionally associating it with a category.
    ///
    /// This method uses `nextQuestionId` to generate a unique identifier for the new question. If a `Category`
    /// is provided, the question will be associated with it by calling the `bind(category:with:)` method.
    ///
    /// - Parameter category: An optional `Category` to associate the question with. Defaults to `nil`.
    /// - Returns: A newly created `Question` object with a unique identifier, optionally linked to a category.
    func createEmptyQuestion(in category: Category? = nil) -> Question {
        let question = Question(id: nextQuestionId)
        
        if let category = category {
            bind(category: category, with: question)
        }
        
        return question
    }
    
    /// Retrieves an array of `Category` objects that match the specified indices.
    ///
    /// - Parameter indices: An array of integer IDs to filter categories.
    /// - Returns: An array of `Category` objects whose IDs match the given indices.
    func getCategories(of indices: [Int]) -> [Category] {
        categoriesObject.categories.filter { indices.contains($0.id) }
    }
    
    /// Retrieves an array of `Question` objects that match the specified indices.
    ///
    /// - Parameter indices: An array of integer IDs to filter questions.
    /// - Returns: An array of `Question` objects whose IDs match the given indices.
    func getQuestions(of indices: [Int]) -> [Question] {
        questionsObject.questions.filter { indices.contains($0.id) }
    }
    
    // MARK: Save
    /// Saves the current `categoriesObject` and `questionsObject` to the database.
    /// - Parameter database: The `DatabaseController` used to perform the save operation.
    /// - Throws: An error if any of the save operations fail.
    func save(using database: DatabaseController) async throws {
        guard Authentication.isUserValid else { throw Authentication.AuthError.invalidUser }
        
        async let _ = try await saveCategories(using: database)
        async let _ = try await saveQuestions(using: database)
    }
    
    private func saveCategories(using database: DatabaseController) async throws -> Bool {
        guard isInitiallyLoaded.categories else { return false }
        
        //FIXME: JSON LOG
        do {
            let jsonData = try JSONEncoder().encode(categoriesObject)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("CATEGORIES TO SAVE (JSON): \(jsonString)")
            }
        } catch {
            print("Failed to encode categoriesObject to JSON: \(error)")
        }
        
        async let result = try database.saveData(
            categoriesObject,
            into: Constants.categories,
            within: Constants.collection)
        return try await result
    }
    
    private func saveQuestions(using database: DatabaseController) async throws -> Bool {
        guard isInitiallyLoaded.questions else { return false }
        
        //FIXME: JSON LOG
        do {
            let jsonData = try JSONEncoder().encode(questionsObject)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("QUESTIONS TO SAVE (JSON): \(jsonString)")
            }
        } catch {
            print("Failed to encode questionsObject to JSON: \(error)")
        }
        
        async let result = try database.saveData(
            questionsObject,
            into: Constants.questions,
            within: Constants.collection)
        return try await result
    }
    
    // MARK: Load
    /// Asynchronously loads data for `categoriesObject` and `questionsObject` from the database,
    /// then assigns the results to the relevant properties.
    /// - Parameter database: The `DatabaseController` used to perform the load operation.
    /// - Throws: An error if any of the load operations fail.
    func load(using database: DatabaseController) async throws {
        guard Authentication.isUserValid else { throw Authentication.AuthError.invalidUser }
        
        try await loadCategories(using: database)
        try await loadQuestions(using: database)
    }
    
    private func loadCategories(using database: DatabaseController) async throws {
        async let categoriesObject: Categories = try database.loadData(
            from: Constants.categories,
            within: Constants.collection)
        self.categoriesObject = try await categoriesObject
        isInitiallyLoaded.categories = true
    }
    
    private func loadQuestions(using database: DatabaseController) async throws {
        async let questionsObject: Questions = try database.loadData(
            from: Constants.questions,
            within: Constants.collection)
        self.questionsObject = try await questionsObject
        isInitiallyLoaded.questions = true
    }
    
    // MARK: Refresh
    /// Refreshes the state of the application using the provided database.
    ///
    /// - Parameter database: The database controller used to save or load data.
    /// - Throws: An error if saving or loading from the database fails, or if the user is invalid.
    func refresh(using database: DatabaseController) async throws {
        guard Authentication.isUserValid else { throw Authentication.AuthError.invalidUser }
        
        if !isInitiallyLoaded.categories {
            try await loadCategories(using: database)
        } else {
            let result = try await saveCategories(using: database)
            if result {
                try await loadCategories(using: database)
            }
        }
        
        if !isInitiallyLoaded.questions {
            try await loadQuestions(using: database)
        } else {
            let result = try await saveQuestions(using: database)
            if result {
                try await loadQuestions(using: database)
            }
        }
    }
    
    // MARK: - Constants
    private struct Constants {
        static let collection = "development"
        static let categories = "categories"
        static let questions = "questions"
    }
}
