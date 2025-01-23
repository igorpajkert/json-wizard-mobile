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
        var searchText: String = ""

        private let store: DataStore
        private let database: DatabaseController
        private let questions: [Question]
        private let parentCategory: Category?

        var searchResults: [Question] {
            if searchText.isEmpty {
                return questions
            } else {
                return questions.filter {
                    $0.questionText.localizedStandardContains(searchText)
                }
            }
        }

        init(
            store: DataStore = DataStore(),
            database: DatabaseController = DatabaseController(),
            questions: [Question] = [],
            parentCategory: Category? = nil
        ) {
            self.store = store
            self.database = database
            self.questions = questions
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
            store.deleteQuestions(with: offsets)
        }

        func refresh() async {
            do {
                try await store.refresh(using: database)
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
