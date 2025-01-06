//
//  Question.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation

/// Model class that defines properties for a question.
@Observable
final class Question: Codable, Identifiable, Equatable {
    let id: Int
    var questionText: String
    var answers: [Answer]
    var categories: [Category]?
    let dateCreated: Date
    
    var answersCount: Int { answers.count }
    var correctAnswersCount: Int { answers.filter(\.isCorrect).count }
    
    init(id: Int, questionText: String = "", answers: [Answer] = [], categories: [Category]? = nil, dateCreated: Date = .now) {
        self.id = id
        self.questionText = questionText
        self.answers = answers
        self.categories = categories
        self.dateCreated = dateCreated
    }
    
    // MARK: - Equatable conformance
    static func == (lhs: Question, rhs: Question) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
}

extension Question {
    var unwrappedCategories: [Category] { categories ?? [] }
}
