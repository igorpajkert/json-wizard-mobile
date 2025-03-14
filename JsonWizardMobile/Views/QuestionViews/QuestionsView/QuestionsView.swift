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
    @Environment(\.colorScheme) private var colorScheme
    
    var parentCategory: Category?
    
    var body: some View {
        List {
            if viewModel.isAdmin {
                CollectionPicker(selection: $viewModel.currentCollectionType)
            }
            questionsList
            questionsCount.isHidden(viewModel.questions.isEmpty)
        }
        .listRowSpacing(10)
        .toolbar {
            toolbarSortButton
            toolbarFilterButton
            toolbarAddButton
        }
        .navigationDestination(item: $viewModel.selectedQuestion) { question in
            QuestionEditView(question: question, viewType: .edit)
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
        .alert("alert_title_delete_question",
               isPresented: $viewModel.isPresentingDeletionAlert,
               actions: {
            Button("button_delete", role: .destructive) {
                viewModel.onDeleteConfirmaiton()
            }
            Button("button_cancel",
                   role: .cancel,
                   action: viewModel.onDeleteCancelation
            )
        }, message: {
            Text("message_delete_question_confirmation")
        })
        .searchable(text: $viewModel.searchText)
        .overlay(alignment: .center) {
            if viewModel.questions.isEmpty {
                ContentUnavailableView(
                    "add_first_question_text",
                    systemImage: "rectangle.stack.badge.plus")
            }
        }
        .onAppear {
            viewModel.set(
                store: store,
                parentCategory: parentCategory
            )
        }
    }
    
    private var questionsList: some View {
        ForEach(viewModel.questions) { question in
            Button {
                viewModel.selectQuestions(question)
            } label: {
                QuestionCardView(question: question)
            }
            .tint(colorScheme == .dark ? .white : .black)
            .swipeActions(allowsFullSwipe: false) {
                SwipeButtonDelete {
                    viewModel.onDelete(question)
                }
            }
        }
    }
    
    private var questionsCount: some View {
        Text("\(viewModel.questions.count) questions_count")
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
    }
    
    // MARK: Toolbar
    private var toolbarAddButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: viewModel.presentNewQuestionSheet) {
                Image(systemName: "plus")
            }
        }
    }
    
    private var toolbarSortButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu("menu_sort", systemImage: "arrow.up.arrow.down") {
                Picker("picker_sort_by", selection: $viewModel.sortOption) {
                    ForEach(Question.SortOptions.allCases) { option in
                        Text(option.name)
                            .tag(option as Question.SortOptions)
                    }
                }
                Picker("picker_sort_order", selection: $viewModel.sortOrder) {
                    Text("text_sort_ascending").tag(SortOrder.forward)
                    Text("text_sort_descending").tag(SortOrder.reverse)
                }
            }
        }
    }
    
    private var toolbarFilterButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu("menu_filter", systemImage: "line.3.horizontal.decrease") {
                Picker("picker_filter_by", selection: $viewModel.filterOption) {
                    ForEach(Question.FilterOptions.allCases) { option in
                        Text(option.name)
                            .tag(option as Question.FilterOptions)
                    }
                }
            }
        }
    }
}

#Preview("All Questions") {
    NavigationStack {
        QuestionsView(parentCategory: nil)
            .navigationTitle("All Questions")
            .environment(\.store, DataStore(questions: Question.sampleData))
    }
}

#Preview("No Data") {
    NavigationStack {
        QuestionsView(parentCategory: nil)
            .navigationTitle("All Questions")
            .environment(\.store, DataStore())
    }
}
