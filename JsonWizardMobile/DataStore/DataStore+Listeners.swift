//
//  DataStore+Listeners.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/02/2025.
//

import Foundation
import FirebaseFirestore

extension DataStore {
    
    func attachListeners(to collection: CollectionType) {
        detachListeners()
        
        switch collection {
        case .development:
            categoriesListener = attachCategoriesListener(to: .devCategories)
            questionsListener = attachQuestionsListener(to: .devQuestions)
            
        case .test:
            categoriesListener = attachCategoriesListener(to: .testCategories)
            questionsListener = attachQuestionsListener(to: .testQuestions)
            
        case .production:
            categoriesListener = attachCategoriesListener(to: .prodCategories)
            questionsListener = attachQuestionsListener(to: .prodQuestions)
        }
    }
    
    private func attachCategoriesListener(to collection: DataStore.Collection) -> ListenerRegistration {
        let db = Firestore.firestore()
        return db.collection(collection.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching category snapshot: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    print("No categories snaphot data available.")
                    return
                }
                
                snapshot.documentChanges.forEach { change in
                    switch change.type {
                    case .added:
                        if let newCategory = try? change.document.data(as: Category.self) {
                            self.categories.append(newCategory)
                        } else {
                            print("Failed to decode new category on addition.")
                        }
                        
                    case .modified:
                        guard let modifiedCategory = try? change.document.data(as: Category.self) else {
                            print("Failed to decode category on modification.")
                            return
                        }
                        if let index = self.categories.firstIndex(where: { $0.id == modifiedCategory.id }) {
                            self.categories[index] = modifiedCategory
                        } else {
                            print("Modified category not found in local array.")
                        }
                        
                    case .removed:
                        guard let removedCategory = try? change.document.data(as: Category.self) else {
                            print("Failed to decode category on removal.")
                            return
                        }
                        
                        self.categories.removeAll { $0.id == removedCategory.id }
                    }
                }
            }
    }
    
    private func attachQuestionsListener(to collection: DataStore.Collection) -> ListenerRegistration {
        let db = Firestore.firestore()
        return db.collection(collection.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching questions snapshot: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    print("No questions snapshot data available.")
                    return
                }
                
                snapshot.documentChanges.forEach { change in
                    switch change.type {
                    case .added:
                        if let newQuestion = try? change.document.data(as: Question.self) {
                            self.questions.append(newQuestion)
                        } else {
                            print("Failed to decode new question on addition.")
                        }
                        
                    case .modified:
                        guard let modifiedQuestion = try? change.document.data(as: Question.self) else {
                            print("Failed to decode question on modification.")
                            return
                        }
                        
                        if let index = self.questions.firstIndex(where: { $0.id == modifiedQuestion.id }) {
                            self.questions[index] = modifiedQuestion
                        } else {
                            print("Modified question not found in local array.")
                        }
                        
                    case .removed:
                        guard let removedQuestion = try? change.document.data(as: Question.self) else {
                            print("Failed to decode question on removal.")
                            return
                        }
                        
                        self.questions.removeAll { $0.id == removedQuestion.id }
                    }
                }
            }
    }
    
    func detachListeners() {
        detachCategoriesListener()
        detachQuestionsListener()
    }
    
    private func detachCategoriesListener() {
        categoriesListener?.remove()
    }
    
    private func detachQuestionsListener() {
        questionsListener?.remove()
    }
}
