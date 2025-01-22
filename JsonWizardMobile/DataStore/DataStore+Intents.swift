//
//  DataStore+Intents.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/01/2025.
//

import Foundation

// MARK: Intents
extension DataStore {
    
    // MARK: Bindings
    func bind(category: Category, with question: Question) {
        category.questionIDs.appendIfNotContains(question.id)
        question.categoryIDs.appendIfNotContains(category.id)
        print("Bound category \(category.id) to question \(question.id)")
    }
    
    func unbind(category: Category, from question: Question) {
        category.questionIDs.removeAll { $0 == question.id }
        question.categoryIDs.removeAll { $0 == category.id }
        print("Unbound category \(category.id) from question \(question.id)")
    }
    
    func isBound(category: Category, with question: Question) -> Bool {
        category.questionIDs.contains(question.id) && question.categoryIDs.contains(category.id)
    }
    
    func unbindAll(from question: Question) {
        for categoryID in question.categoryIDs {
            let category = categoriesObject.categories.first { $0.id == categoryID }
            category?.questionIDs.removeAll { $0 == question.id }
            print("Unbound category \(categoryID) from question \(question.id)")
        }
    }
    
    func unbindAll(from category: Category) {
        for questionID in category.questionIDs {
            let question = questionsObject.questions.first { $0.id == questionID }
            question?.categoryIDs.removeAll { $0 == category.id }
            print("Unbound question \(questionID) from category \(category.id)")
        }
    }
    
    // MARK: Categories
    func addCategory(_ category: Category) {
        categoriesObject.categories.append(category)
    }
    
    //FIXME: Unbind all questions from category
    func deleteCategories(with offsets: IndexSet) {
        let categoriesToDelete = offsets.map { categoriesObject.categories[$0] }
        
        categoriesObject.categories.remove(atOffsets: offsets)
        
        categoriesToDelete.forEach { category in
            questionsObject.questions.forEach { question in
                question.categoryIDs.removeAll { $0 == category.id }
            }
        }
    }
    
    // MARK: Questions
    func addQuestion(_ question: Question) {
        questionsObject.questions.append(question)
    }
    
    //FIXME: Unbind all categories from question
    func deleteQuestions(with offsets: IndexSet) {
        let questionsToDelete = offsets.map { questionsObject.questions[$0] }
        
        questionsObject.questions.remove(atOffsets: offsets)
        
        questionsToDelete.forEach { question in
            categoriesObject.categories.forEach { category in
                category.questionIDs.removeAll { $0 == question.id }
            }
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
