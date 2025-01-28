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
        
        private var store: DataStore
        private var parentCategory: Category?
        
        var questions: [Question] {
            var result = store.questionsObject.questions
            
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
        
        init(
            store: DataStore = DataStore(),
            parentCategory: Category? = nil
        ) {
            self.store = store
            self.parentCategory = parentCategory
        }
        
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
        
        func deleteQuestions(with offsets: IndexSet) {
            let questionIDsToDelete = offsets.map { questions[$0].id }
            store.delete(questions: questionIDsToDelete)
        }
        
        func refresh() async {
            do {
                try await store.refresh()
            } catch Authentication.AuthError.invalidUser {
                errorWrapper = .init(
                    error: Authentication.AuthError.invalidUser,
                    guidance: "Could not refresh questions. Sign in to continue.",
                    isDismissable: true,
                    dismissAction: .init(title: "Sign In", action: presentSignInSheet))
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance:
                        "Could not refresh questions. Check if you are properly signed in and try again.",
                    isDismissable: true)
            }
        }
    }
}
