//
//  Question.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation

/// A model class that defines properties and behaviors for a question.
@Observable
final class Question: Codable, Identifiable {
    
    /// A unique identifier for this question.
    let id: Int
    /// The text or prompt for the question.
    var questionText: String
    /// A list of answers associated with this question.
    var answers: [Answer]
    /// An optional list of categories that classify or group this question.
    ///
    /// This might be `nil` if the question has not yet been associated with any category.
    var categories: [Category]?
    /// The date and time when this question was created.
    let dateCreated: Date
    
    /// The total number of answers.
    ///
    /// Equivalent to `answers.count`.
    var answersCount: Int { answers.count }
    /// The total number of answers marked as correct.
    ///
    /// Counts how many items in `answers` have `isCorrect == true`.
    var correctAnswersCount: Int { answers.filter(\.isCorrect).count }
    
    /// Creates a new `Question` instance.
    ///
    /// - Parameters:
    ///   - id: The unique numeric identifier for this question.
    ///   - questionText: The main text or prompt for the question. Defaults to an empty string.
    ///   - answers: An array of possible answers. Defaults to an empty array.
    ///   - categories: An optional array of categories. Defaults to `nil`.
    ///   - dateCreated: The date/time when the question was created. Defaults to the current time (`.now`).
    init(id: Int,
         questionText: String = "",
         answers: [Answer] = [],
         categories: [Category]? = nil,
         dateCreated: Date = .now) {
        self.id = id
        self.questionText = questionText
        self.answers = answers
        self.categories = categories
        self.dateCreated = dateCreated
    }
}

// MARK: - Extension for Convenience
extension Question {
    /// Provides a non-optional array of categories.
    ///
    /// Returns `categories` if present, or an empty array otherwise. Use this
    /// property to avoid unwrapping `categories` in views or logic that
    /// requires a definite `[Category]` rather than an optional.
    var unwrappedCategories: [Category] { categories ?? [] }
}

// MARK: - Equatable Conformance
extension Question: Equatable {
    static func == (lhs: Question, rhs: Question) -> Bool {
        lhs.id == rhs.id && lhs.questionText == rhs.questionText
    }
}
