//
//  QuestionsView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionsView: View {
    
    @State private var isPresentingNewQuestionSheet = false
    @State private var isPresentingSignInSheet = false
    @State private var errorWrapper: ErrorWrapper?
    @State private var searchText = ""
    
    @Environment(\.store) private var store
    @Environment(\.database) private var database
    
    var questions: [Question]
    var parentCategory: Category?
    
    var searchResults: [Question] {
        if searchText.isEmpty {
            return questions
        } else {
            return questions.filter { $0.questionText.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        List {
            questionsList
            questionsCount.isHidden(questions.isEmpty)
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarAddButton
            toolbarSortButton
            toolbarFilterButton
        }
        .sheet(isPresented: $isPresentingNewQuestionSheet, onDismiss: dismissNewQuestionSheet) {
            NewQuestionSheet(parentCategory: parentCategory)
        }
        .sheet(isPresented: $isPresentingSignInSheet, onDismiss: dismissSignInSheet) {
            SignInSheet()
        }
        .sheet(item: $errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .refreshable {
            await refresh()
        }
        .searchable(text: $searchText)
        .overlay(alignment: .center) {
            if questions.isEmpty {
                ContentUnavailableView("add_first_question_text", systemImage: "rectangle.stack.badge.plus")
            }
        }
    }
    
    private var questionsList: some View {
        ForEach(searchResults) { question in
            NavigationLink(destination: QuestionEditView(question: question)) {
                QuestionCardView(question: question)
            }
        }
        .onDelete(perform: store.deleteQuestions)
    }
    
    private var questionsCount: some View {
        Text("\(questions.count) questions_count")
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
    }
    
    // MARK: Toolbar
    private var toolbarAddButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button(action: presentNewQuestionSheet) {
                Image(systemName: "plus")
            }
        }
    }
    
    private var toolbarSortButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {}) {
                Image(systemName: "arrow.up.arrow.down")
            }
        }
    }
    
    private var toolbarFilterButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {}) {
                Image(systemName: "line.3.horizontal.decrease")
            }
        }
    }
    
    // MARK: - Intents
    private func presentNewQuestionSheet() {
        isPresentingNewQuestionSheet = true
        
    }
    
    private func dismissNewQuestionSheet() {
        isPresentingNewQuestionSheet = false
    }
    
    private func refresh() async {
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
                guidance: "Could not refresh questions. Check if you are properly signed in and try again.",
                isDismissable: true)
        }
    }
    
    private func presentSignInSheet() {
        isPresentingSignInSheet = true
    }
    
    private func dismissSignInSheet() {
        isPresentingSignInSheet = false
    }
}

#Preview("All Questions") {
    NavigationStack {
        QuestionsView(questions: Question.sampleData)
            .navigationTitle("All Questions")
    }
}

#Preview("Without Toolbar") {
    QuestionsView(questions: Question.sampleData)
}

#Preview("No Data") {
    NavigationStack {
        QuestionsView(questions: [])
    }
}
