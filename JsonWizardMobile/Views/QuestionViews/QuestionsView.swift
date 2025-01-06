//
//  QuestionsView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionsView: View {
    
    @State private var isPresentingNewQuestionSheet = false
    
    @Environment(\.store) private var store
    
    var questions: [Question]
    
    var body: some View {
        List {
            questionsList
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarAddButton
        }
        .sheet(isPresented: $isPresentingNewQuestionSheet, onDismiss: dismissNewQuestionSheet) {
            NewQuestionSheet(question: store.createEmptyQuestion())
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
