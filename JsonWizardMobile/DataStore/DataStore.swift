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
    private(set) var categories = [Category]()
    /// Holds a list of `Question` objects (read-only externally).
    private(set) var questions = [Question]()
    
    /// Calculates and returns the next question's unique ID.
    var nextQuestionId : Int { questions.maxId + 1 }
    
    /// Creates a new question with a unique identifier.
    ///
    /// This function generates a `Question` object using a unique ID provided
    /// by the `nextQuestionId()` function. The `Question` object will have
    /// default or empty properties.
    ///
    /// - Returns: A newly created `Question` object with a unique identifier.
    func createEmptyQuestion() -> Question {
        Question(id: nextQuestionId)
    }
    
    // MARK: - Intents
    // NOTE: Questions
    func addQuestion(_ question: Question) {
        questions.append(question)
    }
    
    func deleteQuestions(at offsets: IndexSet) {
        questions.remove(atOffsets: offsets)
    }
    
    // NOTE: Answers
    func addAnswer(to question: Question, with text: String) {
        question.answers.append(Answer(id: question.answers.endIndex, answerText: text))
    }
    
    func deleteAnswers(for question: Question, at offsets: IndexSet) {
        question.answers.remove(atOffsets: offsets)
    }
}
