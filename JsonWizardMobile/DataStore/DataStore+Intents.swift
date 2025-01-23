//
//  DataStore+Intents.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/01/2025.
//

import Foundation

// MARK: Intents
extension DataStore {
    
    // MARK: Binding
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
    
    func unbindAll(from question: Question) {
        for categoryID in question.categoryIDs {
            let category = categoriesObject.categories.first { $0.id == categoryID }
            category?.questionIDs.removeAll { $0 == question.id }
        }
    }
    
    func unbindAll(from category: Category) {
        for questionID in category.questionIDs {
            let question = questionsObject.questions.first { $0.id == questionID }
            question?.categoryIDs.removeAll { $0 == category.id }
        }
    }
    
    // MARK: Categories
    func addCategory(_ category: Category) {
        categoriesObject.categories.append(category)
    }
    
    func deleteCategories(with offsets: IndexSet) {
        let categoriesToDelete = offsets.map { categoriesObject.categories[$0] }
        
        categoriesObject.categories.remove(atOffsets: offsets)
        
        categoriesToDelete.forEach { category in
            unbindAll(from: category)
        }
    }
    
    // MARK: Questions
    func addQuestion(_ question: Question) {
        questionsObject.questions.append(question)
    }
    
    func deleteQuestions(with offsets: IndexSet) {
        let questionsToDelete = offsets.map { questionsObject.questions[$0] }
        
        questionsObject.questions.remove(atOffsets: offsets)
        
        questionsToDelete.forEach { question in
            unbindAll(from: question)
        }
    }
    
    // MARK: Answers
    func addAnswer(at question: Question, with text: String) {
        question.answersObject.answers.append(Answer(id: question.answersObject.answers.endIndex, answerText: text))
    }
    
    func deleteAnswers(at question: Question, with offsets: IndexSet) {
        question.answersObject.answers.remove(atOffsets: offsets)
    }
}
