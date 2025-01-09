//
//  Question.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation

/// A model class that defines properties and behaviors for a question.
@Observable
final class Question: Identifiable, Codable {
    
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
    
    // MARK: - Codable Conformance | Custom encoding & decoding
    /// Initializes the model by decoding from a `Decoder`.
    /// - Parameter decoder: The decoder containing the data to decode.
    /// - Throws: An error if decoding fails for any of the properties.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.questionText = try container.decode(String.self, forKey: .questionText)
        self.answers = try container.decode([Answer].self, forKey: .answers)
        self.categories = try container.decodeIfPresent([Category].self, forKey: .categories)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    /// Encodes the model into an `Encoder`.
    /// - Parameter encoder: The encoder to write the data into.
    /// - Throws: An error if encoding fails for any of the properties.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(questionText, forKey: .questionText)
        try container.encode(answers, forKey: .answers)
        try container.encodeIfPresent(categories, forKey: .categories)
        try container.encode(dateCreated, forKey: .dateCreated)
    }
    
    /// Keys for encoding and decoding properties.
    private enum CodingKeys: String, CodingKey {
        case id, questionText, answers, categories, dateCreated
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

// MARK: - Nameable Conformance
extension Question: Nameable {
    var name: String { questionText }
}
