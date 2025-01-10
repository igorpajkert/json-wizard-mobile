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
    
    // MARK: - Save & Load
    func save(using database: DatabaseController) throws {
        try database.saveData(categoriesObject, into: Constants.categories, within: Constants.collection)
        try database.saveData(questionsObject, into: Constants.questions, within: Constants.collection)
    }
    
    func load(using database: DatabaseController) async throws {
        async let categoriesObject: Categories = try database.loadData(from: Constants.categories, within: Constants.collection)
        async let questionsObject: Questions = try database.loadData(from: Constants.questions, within: Constants.collection)
        self.categoriesObject = try await categoriesObject
        self.questionsObject = try await questionsObject
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
        question.answers.append(Answer(id: question.answers.endIndex, answerText: text))
    }
    
    func deleteAnswers(at question: Question, with offsets: IndexSet) {
        question.answers.remove(atOffsets: offsets)
    }
    
    private struct Constants {
        static let collection = "development"
        static let categories = "categories"
        static let questions = "questions"
    }
}
