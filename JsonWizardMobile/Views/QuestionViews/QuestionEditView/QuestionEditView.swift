//
//  QuestionEditView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionEditView: View {
    
    @State private var viewModel = QuestionEditView.ViewModel()
    
    @Environment(\.store) private var store
    
    var question: Question
    var parentCategory: Category?
    
    var body: some View {
        List {
            questionContent
            answersContent
        }
        .listRowSpacing(10)
        .sheet(
            isPresented: $viewModel.isPresentingCategoriesPickerSheet,
            onDismiss: viewModel.dismissCategoriesPickerSheet
        ) {
            CategoriesPickerSheet(question: question, parentCategory: parentCategory)
        }
        .sheet(item: $viewModel.errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .onAppear {
            if !viewModel.isSet {
                viewModel.set(
                    store: store,
                    question: question,
                    parentCategory: parentCategory
                )
            }
        }
        .onDisappear {
            viewModel.updateQuestion()
        }
    }
    
    // MARK: Question
    private var questionContent: some View {
        Group {
            Section("section_question") {
                TextField("text_question_text",
                          text: $viewModel.question.questionText,
                          axis: .vertical
                )
            }
            Section("section_categories") {
                categoriesContent
                creationDate
            }
        }
    }
    
    private var categoriesContent: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.categories) { category in
                        CategoryBadge(category: category)
                    }
                }
            }
            .scrollIndicators(.never)
            Spacer()
            Button(action: viewModel.presentCategoriesPickerSheet) {
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
            ForEach(question.answers) { answer in
                AnswerCardView(answer: answer)
            }
            .onDelete(perform: viewModel.deleteAnswers)
            HStack {
                TextField("Add Answer...",
                          text: $viewModel.newAnswerText,
                          axis: .vertical
                )
                Button(action: viewModel.addAnswer) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(viewModel.newAnswerText.isEmpty)
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
             DataStore(categories: [
                .init(
                    title: "General Knowledge",
                    color: .inProgress
                ),
                .init(
                    title: "Obesity",
                    color: .red
                ),
                .init(
                    title: "First Aid"
                )
             ]))
    }
}
