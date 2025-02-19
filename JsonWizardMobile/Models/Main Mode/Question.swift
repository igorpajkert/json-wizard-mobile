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
    var questionText: String {
        didSet {
            dateModified = .now
        }
    }
    /// A list of answers associated with this question.
    var answers: [Answer]
    /// An optional list of categories that classify or group this question.
    ///
    /// This might be `nil` if the question has not yet been associated with any category.
    var categoryIDs: [Int]
    /// The date and time when this question was created.
    let dateCreated: Date
    /// Last modification date.
    var dateModified: Date
    
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
    init(
        id: Int = Int.randomID(),
        questionText: String = "",
        answers: [Answer] = [],
        categories: [Category] = [],
        dateCreated: Date = .now,
        dateModified: Date = .now
    ) {
        self.id = id
        self.questionText = questionText
        self.answers = answers
        self.categoryIDs = categories.map { $0.id }
        self.dateCreated = dateCreated
        self.dateModified = dateModified
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
        self.categoryIDs = try container.decode([Int].self, forKey: .categoryIDs)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.dateModified = try container.decode(String.self, forKey: .dateModified).toDate()
    }
    
    /// Encodes the model into an `Encoder`.
    /// - Parameter encoder: The encoder to write the data into.
    /// - Throws: An error if encoding fails for any of the properties.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(questionText, forKey: .questionText)
        try container.encode(answers, forKey: .answers)
        try container.encode(categoryIDs, forKey: .categoryIDs)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateModified.toString(), forKey: .dateModified)
    }
    
    /// Keys for encoding and decoding properties.
    private enum CodingKeys: String, CodingKey {
        case id, questionText, answers, categoryIDs, dateCreated, dateModified
    }
}

// MARK: - Equatable Conformance
extension Question: Equatable {
    static func == (lhs: Question, rhs: Question) -> Bool {
        lhs.id == rhs.id &&
        lhs.questionText == rhs.questionText &&
        lhs.answers == rhs.answers &&
        lhs.categoryIDs == rhs.categoryIDs &&
        lhs.dateCreated == rhs.dateCreated &&
        lhs.dateModified == rhs.dateModified
    }
}

// MARK: - Nameable Conformance
extension Question: Nameable {
    var name: String { questionText }
}

// MARK: - Hashable Conformance
extension Question: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Sorting
extension Question {
    /// Represents the sorting options available for `Question` instances.
    enum SortOptions: String, CaseIterable, Identifiable, Nameable {
        case recent
        case alphabetical
        case categoriesCount
        case answersCount
        
        var id: String { rawValue }
        
        /// A localized name for the sorting option.
        var name: String {
            switch self {
            case .recent:
                return String(localized: "sort_options_recent")
            case .alphabetical:
                return String(localized: "sort_options_alphabetical")
            case .categoriesCount:
                return String(localized: "sort_options_categories_count")
            case .answersCount:
                return String(localized: "sort_options_answers_count")
            }
        }
    }
}

// MARK: - Filtering
extension Question {
    /// Represents the filtering options available for `Question` instances.
    enum FilterOptions: String, CaseIterable, Identifiable, Nameable {
        case none
        case categorized
        case uncategorized
        case withAnswers
        case withoutAnswers
        case withCorrectAnswers
        case withoutCorrectAnswers
        
        var id: String { rawValue }
        
        /// A localized name for the filter option.
        var name: String {
            switch self {
            case .none:
                return String(localized: "filter_options_none")
            case .categorized:
                return String(localized: "filter_options_categorized")
            case .uncategorized:
                return String(localized: "filter_options_uncategorized")
            case .withAnswers:
                return String(localized: "filter_options_with_answers")
            case .withoutAnswers:
                return String(localized: "filter_options_without_answers")
            case .withCorrectAnswers:
                return String(localized: "filter_options_with_correct_answers")
            case .withoutCorrectAnswers:
                return String(localized: "filter_options_without_correct_answers")
            }
        }
    }
}
