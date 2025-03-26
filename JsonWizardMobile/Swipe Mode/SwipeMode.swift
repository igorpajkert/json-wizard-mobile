//
//  SwipeMode.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/03/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class SwipeMode {
    
    var selectedQuestion: SwipeQuestion?
    var errorWrapper: ErrorWrapper?
    var questionToDelete: SwipeQuestion?
    
    private(set) var questions = [SwipeQuestion]()
    
    private var currentCollection: CollectionType?
    private var listener: ListenerRegistration?
    
    var selectedCollection: CollectionType {
        get {
            currentCollection ?? .test
        }
        set {
            switchCollection(to: newValue)
        }
    }
    
    init(
        questions: [SwipeQuestion] = [SwipeQuestion]()
    ) {
        self.questions = questions
    }
    
    func fetchData() async throws {
        setCollection()
        
        if let currentCollection = currentCollection {
            let db = DatabaseController()
            questions = try await db.getAllDocuments(from: currentCollection.rawValue)
            attachListener(to: currentCollection)
        }
    }
    
    private func attachListener(to collection: CollectionType) {
        detachListener()
        
        let db = Firestore.firestore()
        listener = db.collection(collection.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching swipe questions snapshot: \(error)")
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    print("No swipe questions snapshot available.")
                    return
                }
                
                guard snapshot.metadata.isFromCache == false else {
                    return
                }
                
                snapshot.documentChanges.forEach { change in
                    switch change.type {
                    case .added:
                        if let newSwipeQuestion = try? change.document.data(as: SwipeQuestion.self) {
                            self.questions.append(newSwipeQuestion)
                        } else {
                            print("Failed to decode new swipe question on addition.")
                        }
                        
                    case .modified:
                        guard let modifiedSwipeQuestion = try? change.document.data(as: SwipeQuestion.self) else {
                            print("Failed to decode modified swipe question.")
                            return
                        }
                        if let index = self.questions.firstIndex(where: { $0.id == modifiedSwipeQuestion.id }) {
                            self.questions[index] = modifiedSwipeQuestion
                        } else {
                            print("Modified swipe question not found in local array.")
                        }
                        
                    case .removed:
                        guard let removedSwipeQuestion = try? change.document.data(as: SwipeQuestion.self) else {
                            print("Failed to decode swipe question on removal.")
                            return
                        }
                        self.questions.removeAll { $0.id == removedSwipeQuestion.id }
                    }
                }
            }
    }
    
    private func detachListener() {
        listener?.remove()
    }
    
    private func setCollection() {
        if currentCollection == nil {
            currentCollection = getCollection()
        }
    }
    
    private func switchCollection(to collection: CollectionType) {
        currentCollection = collection
        questions = []
        
        Task {
            do {
                try await fetchData()
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: "guidance_switch_collection_fetch_failed"
                )
            }
        }
        
        attachListener(to: collection)
    }
    
    private func update(_ question: SwipeQuestion) {
        let db = DatabaseController()
        do {
            if let collection = currentCollection?.rawValue {
                try db.set(question, in: question.id.toString(), within: collection)
            }
        } catch {
            errorWrapper = .init(
                error: error,
                guidance: "guidance_update_swipe_question_failed"
            )
        }
    }
    
    // MARK: - Intents
    func addQuestion(_ question: SwipeQuestion) {
        update(question)
    }
    
    func addQuestion(with text: String, isCorrect: Bool) {
        let newQuestion = SwipeQuestion(text: text, isCorrect: isCorrect)
        addQuestion(newQuestion)
    }
    
    func deleteQuestion() {
        guard let question = questionToDelete?.id.toString(),
              let collection = currentCollection?.rawValue else { return }
        
        Task {
            do {
                let db = DatabaseController()
                try await db.delete(document: question, within: collection)
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: "guidance_error_deleting_swipe_question"
                )
            }
        }
    }
}
