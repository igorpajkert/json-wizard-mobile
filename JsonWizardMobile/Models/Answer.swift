//
//  Answer.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation

/// A model that represents a single answer option in a question.
@Observable
final class Answer: Codable, Identifiable {
    
    /// A unique identifier for the answer.
    let id: Int
    /// The text content of this answer option.
    var answerText: String
    /// Indicates whether this answer is correct.
    var isCorrect: Bool
    
    /// Creates a new `Answer` instance.
    ///
    /// - Parameters:
    ///   - id: A unique numeric identifier.
    ///   - answerText: The text for this answer. Defaults to an empty string.
    ///   - isCorrect: Whether this answer is correct. Defaults to `false`.
    init(id: Int,
         answerText: String = "",
         isCorrect: Bool = false) {
        self.id = id
        self.answerText = answerText
        self.isCorrect = isCorrect
    }
}

// MARK: Equatable Conformance
extension Answer: Equatable {
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        lhs.id == rhs.id &&
        lhs.answerText == rhs.answerText &&
        lhs.isCorrect == rhs.isCorrect
    }
}
