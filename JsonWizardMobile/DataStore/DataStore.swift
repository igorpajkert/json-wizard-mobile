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
    
    /// Creates and returns a new question with a unique identifier.
    ///
    /// This function uses `nextQuestionId()` to provide a unique ID for the `Question`.
    /// By default, the resulting `Question` has only an ID and otherwise empty or default
    /// properties. You can populate additional fields after creation.
    ///
    /// - Returns: A newly created `Question` object with a unique identifier.
    func createEmptyQuestion() -> Question {
        Question(id: nextQuestionId)
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
        
        async let result = try database.saveData(
            categoriesObject,
            into: Constants.categories,
            within: Constants.collection)
        return try await result
    }
    
    private func saveQuestions(using database: DatabaseController) async throws -> Bool {
        guard isInitiallyLoaded.questions else { return false }
        
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
    
    // MARK: - Intents
    // NOTE: Categories
    func addCategory(_ category: Category) {
        categoriesObject.categories.append(category)
    }
    
    func deleteCategories(with offsets: IndexSet) {
        categoriesObject.categories.remove(atOffsets: offsets)
    }
    
    // NOTE: Questions
    func addQuestion(_ question: Question) {
        questionsObject.questions.append(question)
    }
    
    func deleteQuestions(with offsets: IndexSet) {
        questionsObject.questions.remove(atOffsets: offsets)
    }
    
    // NOTE: Answers
    func addAnswer(at question: Question, with text: String) {
        question.answersObject.answers.append(Answer(id: question.answersObject.answers.endIndex, answerText: text))
    }
    
    func deleteAnswers(at question: Question, with offsets: IndexSet) {
        question.answersObject.answers.remove(atOffsets: offsets)
    }
    
    // MARK: - Constants
    private struct Constants {
        static let collection = "development"
        static let categories = "categories"
        static let questions = "questions"
    }
}
