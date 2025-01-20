//
//  QuestionEditView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionEditView: View {
    
    @State private var newAnswerText = ""
    @State private var isPresentingCategoriesPickerSheet = false
    
    @Environment(\.store) private var store
    
    @Bindable var question: Question
    
    private var categories: [Category] {
        store.getCategories(of: question.categoryIDs)
    }
    
    var body: some View {
        List {
            questionContent
            answersContent
        }
        .listRowSpacing(10)
        .sheet(isPresented: $isPresentingCategoriesPickerSheet, onDismiss: dismissCategoriesPickerSheet) {
            CategoriesPickerSheet(question: question)
        }
    }
    
    // MARK: Question
    private var questionContent: some View {
        Section("Question") {
            TextField("Question Text", text: $question.questionText, axis: .vertical)
            HStack {
                HStack {
                    ForEach(categories) { category in
                        CategoryBadge(category: category)
                    }
                }
                Spacer()
                // TODO: Categories adding
                Button(action: presentCategoriesPickerSheet) {
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
            ForEach(question.answersObject.answers) { answer in
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
    
    private func presentCategoriesPickerSheet() {
        isPresentingCategoriesPickerSheet = true
    }
    
    private func dismissCategoriesPickerSheet() {
        isPresentingCategoriesPickerSheet = false
    }
}

#Preview {
    NavigationStack {
        QuestionEditView(question: Question.sampleData[0])
    }
}
