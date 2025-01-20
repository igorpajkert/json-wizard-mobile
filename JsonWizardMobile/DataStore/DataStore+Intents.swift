//
//  DataStore+Intents.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/01/2025.
//

import Foundation

extension Array {
    mutating func appendIfNotContains(_ newElement: Element) where Element: Equatable {
        if !contains(newElement) {
            append(newElement)
        }
    }
}

// MARK: Intents
extension DataStore {
    
    // MARK: Bindings
    func bind(category: Category, with question: Question) {
        category.questionIDs.appendIfNotContains(question.id)
        question.categoryIDs.appendIfNotContains(category.id)
    }
    
    func unbind(category: Category, from question: Question) {
        category.questionIDs.removeAll { $0 == question.id }
        question.categoryIDs.removeAll { $0 == category.id }
    }
    
    func isBound(category: Category, with question: Question) -> Bool {
        category.questionIDs.contains(question.id) && question.categoryIDs.contains(category.id)
    }
    
    // MARK: Categories
    func addCategory(_ category: Category) {
        categoriesObject.categories.append(category)
    }
    
    func deleteCategories(with offsets: IndexSet) {
        categoriesObject.categories.remove(atOffsets: offsets)
    }
    
    // MARK: Questions
    func addQuestion(_ question: Question) {
        questionsObject.questions.append(question)
    }
    
    func deleteQuestions(with offsets: IndexSet) {
        questionsObject.questions.remove(atOffsets: offsets)
    }
    
    // MARK: Answers
    func addAnswer(at question: Question, with text: String) {
        question.answersObject.answers.append(Answer(id: question.answersObject.answers.endIndex, answerText: text))
    }
    
    func deleteAnswers(at question: Question, with offsets: IndexSet) {
        question.answersObject.answers.remove(atOffsets: offsets)
    }
}
