//
//  QuestionsView+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 23/01/2025.
//

import SwiftUI

extension QuestionsView {
    
    @Observable
    class ViewModel {
        
        var isPresentingNewQuestionSheet = false
        var isPresentingSignInSheet = false
        
        var errorWrapper: ErrorWrapper?
        
        var searchText = ""
        var sortOrder = SortOrder.forward
        var sortOption = Question.SortOptions.recent
        var filterOption = Question.FilterOptions.none
        
        var isPresentingDeletionAlert = false
        private var questionToDelete: Question?
        
        var selectedQuestion: Question?
        
        private var isSet = false
        private var store = DataStore()
        private var parentCategory: Category? = nil
        
        var isAdmin: Bool {
            Authentication.shared.userData?.role == .admin
        }
        
        var currentCollectionType: DataStore.CollectionType {
            get {
                store.currentCollectionType
            }
            set {
                store.switchCollection(to: newValue)
            }
        }
        
        var questions: [Question] {
            var result = store.questions
            
            if let parentCategory = parentCategory {
                result = result.filter { question in
                    question.categoryIDs.contains(parentCategory.id)
                }
            }
            
            // Filter questions based on the search text
            if !searchText.isEmpty {
                result = result.filter {
                    $0.questionText.localizedStandardContains(searchText)
                }
            }
            
            // Apply filtering based on the filterOption
            switch filterOption {
            case .none:
                break
            case .categorized:
                result = result.filter { !$0.categoryIDs.isEmpty }
            case .uncategorized:
                result = result.filter { $0.categoryIDs.isEmpty }
            case .withAnswers:
                result = result.filter { $0.answersCount > 0 }
            case .withoutAnswers:
                result = result.filter { $0.answersCount == 0 }
            case .withCorrectAnswers:
                result = result.filter { $0.correctAnswersCount > 0 }
            case .withoutCorrectAnswers:
                result = result.filter { $0.correctAnswersCount == 0 }
            }
            
            // Apply sorting based on the sortOption
            switch sortOption {
            case .recent:
                result.sort { $0.dateCreated > $1.dateCreated }
            case .alphabetical:
                result.sort { $0.questionText < $1.questionText }
            case .answersCount:
                result.sort { $0.answersCount > $1.answersCount }
            case .categoriesCount:
                result.sort { $0.categoryIDs.count > $1.categoryIDs.count }
                
            }
            
            // Reverse the order if sortOrder is descending
            if sortOrder == .reverse {
                result.reverse()
            }
            
            return result
        }
        
        func set(store: DataStore, parentCategory: Category?) {
            guard isSet == false else { return }
            self.store = store
            self.parentCategory = parentCategory
            isSet = true
        }
        
        // MARK: - Intents
        func presentNewQuestionSheet() {
            isPresentingNewQuestionSheet = true
        }
        
        func dismissNewQuestionSheet() {
            isPresentingNewQuestionSheet = false
        }
        
        func presentSignInSheet() {
            isPresentingSignInSheet = true
        }
        
        func dismissSignInSheet() {
            isPresentingSignInSheet = false
        }
        
        private func presentDeletionAlert(for question: Question) {
            questionToDelete = question
            isPresentingDeletionAlert = true
        }
        
        private func dismissDeletionAlert() {
            questionToDelete = nil
        }
        
        private func deleteQuestion() {
            guard let questionToDelete = questionToDelete else { return }
            do {
                let ids = [questionToDelete.id]
                try store.delete(questions: ids)
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_failed_to_delete_questions_generic"),
                    isDismissable: true
                )
            }
        }
        
        func selectQuestions(_ question: Question) {
            selectedQuestion = question
        }
        
        // MARK: - Events
        func onDelete(_ question: Question) {
            presentDeletionAlert(for: question)
        }
        
        func onDeleteConfirmaiton() {
            deleteQuestion()
        }
        
        func onDeleteCancelation() {
            dismissDeletionAlert()
        }
    }
}
