//
//  QuestionsView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionsView: View {
    var questions: [Question]
    @State private var isPresentingNewQuestionSheet = false
    @Environment(\.store) private var store
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(questions) { question in
                    NavigationLink(destination: QuestionEditView(question: question)) {
                        QuestionCardView(question: question)
                    }
                }
                .onDelete(perform: store.deleteQuestions)
            }
            .listRowSpacing(10)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: presentNewQuestionSheet) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresentingNewQuestionSheet, onDismiss: dismissNewQuestionSheet) {
            NewQuestionSheet(question: store.createEmptyQuestion())
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
