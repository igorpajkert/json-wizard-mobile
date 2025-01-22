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
        Group {
            Section("Question") {
                TextField("Question Text", text: $question.questionText, axis: .vertical)
            }
            Section("Categories") {
                categoriesContent
                creationDate
            }
        }
    }
    
    private var categoriesContent: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories) { category in
                        CategoryBadge(category: category)
                    }
                }
            }
            Spacer()
            Button(action: presentCategoriesPickerSheet) {
                Image(systemName: "plus.circle")
            }
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
        QuestionEditView(question: .init(id: 0, questionText: "Test", categories: [.init(id: 0), .init(id: 1), .init(id: 2)]))
            .environment(\.store, DataStore(
                categoriesObject: .init(
                    categories:
                        [.init(
                            id: 0,
                            title: "General Knowledge",
                            color: .lightLavender),
                         .init(
                            id: 1,
                            title: "Obesity",
                            color: .pink),
                         .init(
                            id: 2,
                            title: "Diabetes",
                            color: .done),
                        ])))
    }
}
