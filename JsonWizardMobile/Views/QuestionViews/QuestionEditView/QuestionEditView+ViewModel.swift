//
//  QuestionEditView+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 23/01/2025.
//

import SwiftUI

extension QuestionEditView {
    
    @Observable
    class ViewModel {
        
        var isPresentingCategoriesPickerSheet = false
        var question = Question()
        var newAnswerText = ""
        var errorWrapper: ErrorWrapper?
        
        private(set) var isSet = false
        
        private var store = DataStore()
        private var parentCategory: Category? = nil
        
        var categories: [Category] {
            var categories = store.getCategories(of: question.categoryIDs)
            if let parentCategory = parentCategory {
                categories.append(parentCategory)
            }
            return categories
        }
        
        func set(store: DataStore, question: Question, parentCategory: Category?) {
            self.store = store
            self.question = question
            self.parentCategory = parentCategory
            isSet = true
        }
        
        func addAnswer() {
            withAnimation {
                do {
                    try store.addAnswer(at: question, with: newAnswerText)
                    newAnswerText.clear()
                } catch {
                    errorWrapper = .init(
                        error: error,
                        guidance: String(localized: "guidance_add_answer_failed_generic"),
                        isDismissable: true)
                }
            }
        }
        
        func deleteAnswers(at offsets: IndexSet) {
            do {
                try store.deleteAnswers(at: question, with: offsets)
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_failed_to_delete_answers_generic"),
                    isDismissable: true)
            }
        }
        
        func presentCategoriesPickerSheet() {
            isPresentingCategoriesPickerSheet = true
        }
        
        func dismissCategoriesPickerSheet() {
            isPresentingCategoriesPickerSheet = false
        }
        
        func updateQuestion() {
            Task {
                do {
                    try store.update(question: question)
                } catch {
                    errorWrapper = .init(
                        error: error,
                        guidance: String(localized: "guidance_failed_to_update_question_generic"),
                        isDismissable: true
                    )
                }
            }
        }
    }
}
