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
    private(set) var categories: [Category]
    /// Holds a list of `Question` objects (read-only externally).
    private(set) var questions: [Question]
    
    /// Calculates and returns the next category's unique ID.
    var nextCategoryId : Int { categories.maxId + 1 }
    /// Calculates and returns the next question's unique ID.
    var nextQuestionId : Int { questions.maxId + 1 }
    
    init(categories: [Category] = [Category](), questions: [Question] = [Question]()) {
        self.categories = categories
        self.questions = questions
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
    
    // MARK: - Intents
    // NOTE: Categories
    func addCategory(_ category: Category) {
        categories.append(category)
    }
    
    func deleteCategories(with offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
    }
    
    // NOTE: Questions
    func addQuestion(_ question: Question) {
        questions.append(question)
    }
    
    func deleteQuestions(with offsets: IndexSet) {
        questions.remove(atOffsets: offsets)
    }
    
    // NOTE: Answers
    func addAnswer(at question: Question, with text: String) {
        question.answers.append(Answer(id: question.answers.endIndex, answerText: text))
    }
    
    func deleteAnswers(at question: Question, with offsets: IndexSet) {
        question.answers.remove(atOffsets: offsets)
    }
}
