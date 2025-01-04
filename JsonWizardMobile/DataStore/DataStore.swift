//
//  DataStore.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import SwiftUI

@Observable
class DataStore {
    
    var categories = [Category]()
    var questions = [Question]()
    
    // FIXME: Debug init
    init(categories: [Category] = Category.sampleData, questions: [Question] = Question.sampleData) {
        self.categories = categories
        self.questions = questions
    }
    
    // MARK: - Intents
    
    // MARK: Answers
    func addAnswer(to question: Question, with text: String) {
        question.answers.append(Answer(id: question.answers.endIndex, answerText: text))
    }
    
    func deleteAnswers(for question: Question, at offsets: IndexSet) {
        question.answers.remove(atOffsets: offsets)
    }
}
