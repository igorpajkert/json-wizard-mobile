//
//  QuestionsView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionsView: View {

    @State private var viewModel = QuestionsView.ViewModel()

    @Environment(\.store) private var store
    @Environment(\.database) private var database

    let questions: [Question]
    let parentCategory: Category?

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
        .sheet(
            isPresented: $viewModel.isPresentingNewQuestionSheet,
            onDismiss: viewModel.dismissNewQuestionSheet
        ) {
            NewQuestionSheet(parentCategory: parentCategory)
        }
        .sheet(
            isPresented: $viewModel.isPresentingSignInSheet,
            onDismiss: viewModel.dismissSignInSheet
        ) {
            SignInSheet()
        }
        .sheet(item: $viewModel.errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .refreshable {
            await viewModel.refresh()
        }
        .searchable(text: $viewModel.searchText)
        .overlay(alignment: .center) {
            if questions.isEmpty {
                ContentUnavailableView(
                    "add_first_question_text", systemImage: "rectangle.stack.badge.plus")
            }
        }
        .onAppear {
            viewModel = .init(
                store: store,
                database: database,
                questions: questions,
                parentCategory: parentCategory)
        }
    }

    private var questionsList: some View {
        ForEach(viewModel.searchResults) { question in
            NavigationLink(destination: QuestionEditView(question: question)) {
                QuestionCardView(question: question)
            }
        }
        .onDelete(perform: viewModel.deleteQuestions)
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
            Button(action: viewModel.presentNewQuestionSheet) {
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
}

#Preview("All Questions") {
    NavigationStack {
        QuestionsView(questions: Question.sampleData, parentCategory: nil)
            .navigationTitle("All Questions")
    }
}

#Preview("No Data") {
    NavigationStack {
        QuestionsView(questions: [], parentCategory: nil)
            .navigationTitle("All Questions")
    }
}
