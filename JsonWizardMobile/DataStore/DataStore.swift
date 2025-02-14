//
//  DataStore.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import SwiftUI
import FirebaseFirestore

/// A data store that manages categories and questions.
@Observable
final class DataStore {
    
    let database = DatabaseController()
    
    var categories: [Category]
    var questions: [Question]
    
    private var categoriesListener: ListenerRegistration? = nil
    private var questionsListener: ListenerRegistration? = nil
    
    init(
        categories: [Category] = [Category](),
        questions: [Question] = [Question]()
    ) {
        self.categories = categories
        self.questions = questions
        
        Task {
            do {
                self.categories = try await database.getAllDocuments(from: Constants.Collection.categories)
                self.questions = try await database.getAllDocuments(from: Constants.Collection.questions)
            } catch {
                print("Unable to fetch data: \(error.localizedDescription)")
            }
        }
        
        categoriesListener = attachCategoriesListener()
        questionsListener = attachQuestionsListener()
    }
    
    deinit {
        categoriesListener?.remove()
        questionsListener?.remove()
    }
    
    func attachCategoriesListener() -> ListenerRegistration {
        let db = Firestore.firestore()
        return db.collection(Constants.Collection.categories)
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
    
    func attachQuestionsListener() -> ListenerRegistration {
        let db = Firestore.firestore()
        return db.collection(Constants.Collection.questions)
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
    
    /// Retrieves an array of `Category` objects that match the specified indices.
    ///
    /// - Parameter indices: An array of integer IDs to filter categories.
    /// - Returns: An array of `Category` objects whose IDs match the given indices.
    func getCategories(of indices: [Int]) -> [Category] {
        categories.filter { indices.contains($0.id) }
    }
    
    /// Retrieves an array of `Question` objects that match the specified indices.
    ///
    /// - Parameter indices: An array of integer IDs to filter questions.
    /// - Returns: An array of `Question` objects whose IDs match the given indices.
    func getQuestions(of indices: [Int]) -> [Question] {
        questions.filter { indices.contains($0.id) }
    }
    
    struct Constants {
        
        struct Collection {
            static let categories = "development_categories"
            static let questions = "development_questions"
        }
    }
}
