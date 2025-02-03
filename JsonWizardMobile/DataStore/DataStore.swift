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
    var categories: [Category]
    /// Holds a list of `Question` objects (read-only externally).
    var questions: [Question]
    
    /// Tracks whether categories and questions are initially loaded.
    private var isInitiallyLoaded = (categories: false, questions: false)
    
    init(categories: [Category] = [Category](),
         questions: [Question] = [Question]()) {
        self.categories = categories
        self.questions = questions
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
    
    // MARK: Save
    /// Saves the current `categoriesObject` and `questionsObject` to the database.
    /// - Throws: An error if any of the save operations fail.
    func save() async throws {
        guard try await Authentication.shared.isUserValid() else {
            throw Authentication.AuthError.invalidUser
        }
        
        async let _ = try await saveCategories()
        async let _ = try await saveQuestions()
    }
    
    private func saveCategories() async throws -> Bool {
        guard isInitiallyLoaded.categories else { return false }
        
        let database = DatabaseController()
        async let result = try database.saveData(
            categories,
            into: Constants.categories,
            within: Constants.collection)
        return try await result
    }
    
    private func saveQuestions() async throws -> Bool {
        guard isInitiallyLoaded.questions else { return false }
        
        let database = DatabaseController()
        async let result = try database.saveData(
            questions,
            into: Constants.questions,
            within: Constants.collection)
        return try await result
    }
    
    // MARK: Load
    /// Asynchronously loads data for `categoriesObject` and `questionsObject` from the database,
    /// then assigns the results to the relevant properties.
    /// - Throws: An error if any of the load operations fail.
    func load() async throws {
        guard try await Authentication.shared.isUserValid() else {
            throw Authentication.AuthError.invalidUser
        }
        
        try await loadCategories()
        try await loadQuestions()
    }
    
    private func loadCategories() async throws {
        let database = DatabaseController()
        async let categories: [Category] = try database.loadData(
            from: Constants.categories,
            within: Constants.collection)
        self.categories = try await categories
        isInitiallyLoaded.categories = true
    }
    
    private func loadQuestions() async throws {
        let database = DatabaseController()
        async let questions: [Question] = try database.loadData(
            from: Constants.questions,
            within: Constants.collection)
        self.questions = try await questions
        isInitiallyLoaded.questions = true
    }
    
    // MARK: Refresh
    /// Refreshes the state of the application using the provided database.
    ///
    /// - Throws: An error if saving or loading from the database fails, or if the user is invalid.
    func refresh() async throws {
        guard try await Authentication.shared.isUserValid() else {
            throw Authentication.AuthError.invalidUser
        }
        
        if !isInitiallyLoaded.categories {
            try await loadCategories()
        } else {
            let result = try await saveCategories()
            if result {
                try await loadCategories()
            }
        }
        
        if !isInitiallyLoaded.questions {
            try await loadQuestions()
        } else {
            let result = try await saveQuestions()
            if result {
                try await loadQuestions()
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
