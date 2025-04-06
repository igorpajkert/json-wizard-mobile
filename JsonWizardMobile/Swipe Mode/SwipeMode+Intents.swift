//
//  SwipeMode+Intents.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/04/2025.
//

import Foundation

extension SwipeMode {
    
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
    func getQuestion(with id: Int) -> SwipeQuestion? {
        questions.first { $0.id == id }
    }
    
    func setQuestion(with id: Int, to value: SwipeQuestion) {
        if let index = questions.firstIndex(where: { $0.id == id }) {
            questions[index] = value
        }
    }
    
    func updateQuestion(_ question: SwipeQuestion) {
        update(question)
    }
    
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
