//
//  QuestionEditView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionEditView: View {
    
    @State private var viewModel: QuestionEditView.ViewModel?
    @State private var newAnswerText = ""
    
    @Environment(\.store) private var store
    
    @Bindable var question: Question
    
    var parentCategory: Category?
    
    private var isPresentigCategoriesPickerSheet: Binding<Bool> {
        Binding(
            get: { viewModel?.isPresentingCategoriesPickerSheet ?? false },
            set: { viewModel?.isPresentingCategoriesPickerSheet = $0 }
        )
    }
    
    private var categories: [Category] {
        viewModel?.categories ?? []
    }
    
    var body: some View {
        List {
            questionContent
            answersContent
        }
        .listRowSpacing(10)
        .sheet(
            isPresented: isPresentigCategoriesPickerSheet,
            onDismiss: viewModel?.dismissCategoriesPickerSheet
        ) {
            CategoriesPickerSheet(question: question)
        }
        .onAppear {
            viewModel = .init(
                store: store, question: question, parentCategory: parentCategory)
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
            Button(action: { viewModel?.presentCategoriesPickerSheet() }) {
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
            .onDelete(perform: viewModel?.deleteAnswers)
            HStack {
                TextField("Add Answer...", text: $newAnswerText, axis: .vertical)
                Button(action: { viewModel?.addAnswer(with: $newAnswerText) }) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newAnswerText.isEmpty)
            }
            answersCount
        }
    }
    
    private var answersCount: some View {
        Text(
            "\(question.answersCount) answers_count, \(question.correctAnswersCount) correct_answers_count"
        )
        .frame(maxWidth: .infinity)
        .font(.footnote)
        .foregroundStyle(.secondary)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    NavigationStack {
        QuestionEditView(
            question: .init(
                id: 0, questionText: "Test",
                categories: [.init(id: 0), .init(id: 1), .init(id: 2)])
        )
        .environment(
            \.store,
             DataStore(
                categoriesObject: .init(
                    categories: [
                        .init(
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
