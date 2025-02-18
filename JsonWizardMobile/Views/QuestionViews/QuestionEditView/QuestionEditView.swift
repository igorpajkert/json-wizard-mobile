//
//  QuestionEditView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

enum QuestionViewType {
    case edit
    case new
}

struct QuestionEditView: View {
    
    @State private var viewModel = QuestionEditView.ViewModel()
    
    @Environment(\.store) private var store
    
    @FocusState private var isTextFieldFocused: Bool
    
    var question: Question
    var parentCategory: Category?
    var viewType: QuestionViewType
    
    var body: some View {
        List {
            questionContent
            answersContent
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarButtonHide
        }
        .sheet(
            isPresented: $viewModel.isPresentingCategoriesPickerSheet,
            onDismiss: viewModel.dismissCategoriesPickerSheet
        ) {
            CategoriesPickerSheet(
                question: question,
                parentCategory: parentCategory,
                viewType: viewType
            )
        }
        .sheet(item: $viewModel.errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .onAppear {
            if !viewModel.isSet {
                viewModel.set(
                    store: store,
                    question: question,
                    parentCategory: parentCategory,
                    viewType: viewType
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
                TextField(
                    "text_question_text",
                    text: $viewModel.question.questionText,
                    axis: .vertical
                )
                .focused($isTextFieldFocused)
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
            HStack {
                TextField("Add Answer...",
                          text: $viewModel.newAnswerText,
                          axis: .vertical
                )
                .focused($isTextFieldFocused)
                Button(action: viewModel.addAnswer) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(viewModel.newAnswerText.isEmpty)
            }
            ForEach(viewModel.answers) { answer in
                AnswerCardView(answer: answer)
            }
            .onDelete(perform: viewModel.deleteAnswers)
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
    
    // MARK: Toolbar
    private var toolbarButtonHide: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            if isTextFieldFocused {
                Spacer()
                Button(
                    "button_hide",
                    systemImage: "keyboard.chevron.compact.down"
                ) {
                    isTextFieldFocused = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuestionEditView(
            question: .init(
                id: 0, questionText: "Test",
                categories: [.init(id: 0), .init(id: 1), .init(id: 2)]),
            viewType: .new
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
