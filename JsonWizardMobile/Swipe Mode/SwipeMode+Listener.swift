//
//  SwipeMode+Listener.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/04/2025.
//

import Foundation
import FirebaseFirestore

extension SwipeMode {
    
    func attachListener(to collection: CollectionType) {
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
}
