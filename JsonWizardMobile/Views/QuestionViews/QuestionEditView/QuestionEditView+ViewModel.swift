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
        private var viewType: QuestionViewType = .new
        
        var categories: [Category] {
            var categories = store.getCategories(of: question.categoryIDs)
            if let parentCategory = parentCategory {
                categories.append(parentCategory)
            }
            return categories
        }
        
        var answers: [Answer] {
            question.answers.reversed()
        }
        
        func set(
            store: DataStore,
            question: Question,
            parentCategory: Category?,
            viewType: QuestionViewType
        ) {
            self.store = store
            self.question = question
            self.parentCategory = parentCategory
            self.viewType = viewType
            isSet = true
        }
        
        func addAnswer() {
            withAnimation {
                do {
                    try store.addAnswer(
                        at: question,
                        with: newAnswerText
                    )
                    newAnswerText.clear()
                } catch {
                    errorWrapper = .init(
                        error: error,
                        guidance: String(
                            localized: "guidance_add_answer_failed_generic"
                        ),
                        isDismissable: true)
                }
            }
        }
        
        func deleteAnswer(_ answer: Answer) {
            withAnimation {
                do {
                    try store.deleteAnswers(
                        at: question,
                        with: [answer.id]
                    )
                } catch {
                    errorWrapper = .init(
                        error: error,
                        guidance: String(
                            localized: "guidance_failed_to_delete_answers_generic"
                        ),
                        isDismissable: true)
                }
            }
        }
        
        func presentCategoriesPickerSheet() {
            isPresentingCategoriesPickerSheet = true
        }
        
        func dismissCategoriesPickerSheet() {
            isPresentingCategoriesPickerSheet = false
        }
        
        func updateQuestion() {
            guard viewType == .edit else { return }
            Task {
                do {
                    try store.update(question: question)
                } catch {
                    errorWrapper = .init(
                        error: error,
                        guidance: String(
                            localized: "guidance_failed_to_update_question_generic"
                        ),
                        isDismissable: true
                    )
                }
            }
        }
    }
}
