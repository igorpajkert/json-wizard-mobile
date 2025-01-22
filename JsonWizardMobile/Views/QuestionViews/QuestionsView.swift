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
    @State private var newQuestion: Question
    
    @Environment(\.store) private var store
    @Environment(\.database) private var database
    
    var questions: [Question]
    var parentCategory: Category?
    
    init (questions: [Question], parentCategory: Category? = nil) {
        self.questions = questions
        self.parentCategory = parentCategory
        self.newQuestion = .init(id: 0)
    }
    
    var body: some View {
        List {
            questionsList
            questionsCount
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarAddButton
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
    }
    
    private var questionsList: some View {
        ForEach(questions) { question in
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
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: presentNewQuestionSheet) {
                Image(systemName: "plus")
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
        if parentCategory != nil {
            newQuestion = store.createEmptyQuestion(in: parentCategory)
        } else {
            newQuestion = store.createEmptyQuestion()
        }
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
