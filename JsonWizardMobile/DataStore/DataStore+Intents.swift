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
    func bind(category: Category, with question: Question, shouldUpdate: Bool) throws {
        category.questionIDs.appendIfNotContains(question.id)
        question.categoryIDs.appendIfNotContains(category.id)
        try update(category: category)
        if shouldUpdate {
            try update(question: question)
        }
    }
    
    func unbind(category: Category, from question: Question, shouldUpdate: Bool) throws {
        category.questionIDs.removeAll { $0 == question.id }
        question.categoryIDs.removeAll { $0 == category.id }
        try update(category: category)
        if shouldUpdate {
            try update(question: question)
        }
    }
    
    func isBound(category: Category, with question: Question) -> Bool {
        category.questionIDs.contains(question.id) &&
        question.categoryIDs.contains(category.id)
    }
    
    private func unbindAll(from question: Question) throws {
        let categoryIDs = question.categoryIDs
        question.categoryIDs.removeAll()
        
        for categoryID in categoryIDs {
            if let category = categories.first(where: { $0.id == categoryID }) {
                category.questionIDs.removeAll { $0 == question.id }
                try update(category: category)
            }
        }
    }
    
    private func unbindAll(from category: Category) throws {
        let questionIDs = category.questionIDs
        category.questionIDs.removeAll()
        
        for questionID in questionIDs {
            if let question = questions.first(where: { $0.id == questionID }) {
                question.categoryIDs.removeAll { $0 == category.id }
                try update(question: question)
            }
        }
    }
    
    func cleanUpBindings() {
        // Clean up questionIDs in categories
        for category in categories {
            var didRemoveInvalidIDs = false
            category.questionIDs.removeAll { questionID in
                let question = questions.first { $0.id == questionID }
                let isInvalid = question == nil || !question!.categoryIDs.contains(category.id)
                if isInvalid {
                    didRemoveInvalidIDs = true
                }
                return isInvalid
            }
            if didRemoveInvalidIDs {
                try? update(category: category)
            }
        }
        
        // Clean up categoryIDs in questions
        for question in questions {
            var didRemoveInvalidIDs = false
            question.categoryIDs.removeAll { categoryID in
                let category = categories.first { $0.id == categoryID }
                let isInvalid = category == nil || !category!.questionIDs.contains(question.id)
                if isInvalid {
                    didRemoveInvalidIDs = true
                }
                return isInvalid
            }
            if didRemoveInvalidIDs {
                try? update(question: question)
            }
        }
    }
    
    // MARK: Categories
    func update(category: Category, shouldUpdateDate: Bool = true) throws {
        if shouldUpdateDate {
            category.dateModified = .now
        }
        
        Task {
            _ = try await database.setData(
                category,
                in: category.id.toString(),
                within: currentCollection.categories.rawValue,
                merge: true
            )
        }
    }
    
    func delete(categories ids: [Int]) throws {
        let categoriesToDelete = getCategories(of: ids)
        
        for category in categoriesToDelete {
            try unbindAll(from: category)
            Task {
                try await database.delete(
                    document: category.id.toString(),
                    within: currentCollection.categories.rawValue
                )
            }
        }
    }
    
    // MARK: Questions
    func update(question: Question) throws {
        question.dateModified = .now
        try updateCategoriesModificationDate(for: question)
        
        Task {
            _ = try await database.setData(
                question,
                in: question.id.toString(),
                within: currentCollection.questions.rawValue,
                merge: true
            )
        }
    }
    
    func delete(questions ids: [Int]) throws {
        let questionsToDelete = getQuestions(of: ids)
        
        for question in questionsToDelete {
            try unbindAll(from: question)
            Task {
                try await database.delete(
                    document: question.id.toString(),
                    within: currentCollection.questions.rawValue
                )
            }
        }
    }
    
    func updateCategoriesModificationDate(for question: Question) throws {
        let categories = getCategories(of: question.categoryIDs)
        for category in categories {
            try update(category: category, shouldUpdateDate: true)
        }
    }
    
    // MARK: Answers
    func addAnswer(at question: Question, with text: String) throws {
        question.answers.append(Answer(answerText: text))
    }
    
    func deleteAnswers(at question: Question, with ids: [Int]) throws {
        question.answers.removeAll { ids.contains($0.id) }
    }
}
