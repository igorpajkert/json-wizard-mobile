//
//  QuestionEditView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionEditView: View {
    
    @State private var newAnswerText = ""
    
    @Environment(\.store) private var store
    
    @Bindable var question: Question
    
    var body: some View {
        List {
            questionContent
            answersContent
        }
        .listRowSpacing(10)
    }
    
    // MARK: Question
    private var questionContent: some View {
        Section("Question") {
            TextField("Question Text", text: $question.questionText, axis: .vertical)
            HStack {
                HStack {
                    ForEach(question.unwrappedCategories) { category in
                        CategoryBadge(category: category)
                    }
                }
                Spacer()
                // TODO: Categories adding
                Button(action: {}) {
                    Image(systemName: "plus.circle")
                }
            }
            creationDate
        }
    }
    
    private var creationDate: some View {
        Text("Created \(question.dateCreated.formatted(date: .long, time: .shortened))")
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
    }
    
    // MARK: Answers
    private var answersContent: some View {
        Section("Answers") {
            ForEach(question.answers) { answer in
                AnswerCardView(answer: answer)
            }
            .onDelete(perform: deleteAnswers)
            HStack {
                TextField("Add Answer...", text: $newAnswerText, axis: .vertical)
                Button(action: addAnswer) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newAnswerText.isEmpty)
            }
            answersCount
        }
    }
    
    private var answersCount: some View {
        Text("\(question.answersCount) answers_count, \(question.correctAnswersCount) correct_answers_count")
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
    }
    
    // MARK: - Intents
    private func addAnswer() {
        withAnimation {
            store.addAnswer(at: question, with: newAnswerText)
            newAnswerText.clear()
        }
    }
    
    private func deleteAnswers(at offsets: IndexSet) {
        store.deleteAnswers(at: question, with: offsets)
    }
}

#Preview {
    NavigationStack {
        QuestionEditView(question: Question.sampleData[0])
    }
}
