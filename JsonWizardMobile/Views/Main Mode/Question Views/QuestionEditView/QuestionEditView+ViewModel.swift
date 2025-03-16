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
        var newAnswerText = ""
        var errorWrapper: ErrorWrapper?
        
        private(set) var isSet = false
        
        private var questionID = 0
        private var newQuestion = Question()
        private var store = DataStore()
        private var parentCategory: Category? = nil
        private var viewType: QuestionViewType = .new
        
        var question: Question {
            get {
                if viewType == .new {
                    return newQuestion
                } else {
                    return store.getQuestion(with: questionID) ?? Question()
                }
            }
            set {
                if viewType == .new {
                    newQuestion = newValue
                } else {
                    let index = store.questions.firstIndex { $0.id == questionID }
                    if let index = index {
                        store.questions[index] = newValue
                    }
                }
            }
        }
        
        var categories: [Category] {
            var categories = store.getCategories(with: question.categoryIDs)
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
            self.questionID = question.id
            self.newQuestion = question
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
