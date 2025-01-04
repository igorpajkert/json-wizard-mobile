//
//  Answer.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation

/// Model class that defines properties for an answer.
@Observable
final class Answer: Codable, Identifiable, Equatable {
    var id: Int
    var answerText: String
    var isCorrect: Bool
    
    init(id: Int, answerText: String = "", isCorrect: Bool = false) {
        self.id = id
        self.answerText = answerText
        self.isCorrect = isCorrect
    }
    
    // MARK: - Equatable conformance
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
}
