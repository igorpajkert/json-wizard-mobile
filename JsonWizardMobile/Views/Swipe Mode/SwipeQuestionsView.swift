//
//  SwipeQuestionsView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/03/2025.
//

import SwiftUI

struct SwipeQuestionsView: View {
    
    @State private var isPresentingNewQuestionSheet = false
    @State private var isPresentingDeletionAlert = false
    
    @Environment(\.swipeMode) private var swipeMode
    
    var isAdmin: Bool {
        Authentication.shared.userData?.role == .admin
    }
    
    var body: some View {
        @Bindable var swipeMode = swipeMode
        
        List {
            if isAdmin {
                SwipeModeCollectionPicker(selection: $swipeMode.selectedCollection)
            }
            
            questions
            
            if !swipeMode.questions.isEmpty {
                questionsCount
            }
        }
        .navigationTitle("title_swipe_mode")
        .listRowSpacing(10)
        .toolbar {
            toolbarButtonSort
            toolbarButtonFilter
            toolbarButtonAdd
        }
        .navigationDestination(item: $swipeMode.selectedQuestion) { question in
            SwipeQuestionEditView(question: question)
        }
        .sheet(item: $swipeMode.errorWrapper) { wrapper in
            ErrorSheet(errorWrapper: wrapper)
        }
        .sheet(
            isPresented: $isPresentingNewQuestionSheet,
            onDismiss: { isPresentingNewQuestionSheet = false }
        ) {
            NewSwipeQuestionSheet()
        }
        .alert(
            "alert_title_swipe_question_delete",
            isPresented: $isPresentingDeletionAlert,
            actions: {
                Button("button_delete", role: .destructive) {
                    swipeMode.deleteQuestion()
                }
                Button("button_cancel", role: .cancel) {
                    swipeMode.questionToDelete = nil
                }
            }, message: {
                Text("message_delete_swipe_question_confirmation")
            }
        )
        .searchable(text: $swipeMode.searchText)
        .overlay(alignment: .center) {
            if swipeMode.questions.isEmpty {
                ContentUnavailableView(
                    "add_first_question_text",
                    systemImage: "plus.square"
                )
            }
        }
        .task {
            do {
                try await swipeMode.fetchData()
            } catch {
                swipeMode.errorWrapper = .init(
                    error: error,
                    guidance: "guidance_swipe_mode_fetch_error",
                    isDismissable: true
                )
            }
        }
    }
    
    private var questions: some View {
        ForEach(swipeMode.filteredQuestions) { question in
            Button {
                swipeMode.selectedQuestion = question
            } label: {
                SwipeQuestionCard(question: question)
            }
            .tint(.primary)
            .swipeActions(allowsFullSwipe: false) {
                SwipeButtonDelete {
                    onDelete(of: question)
                }
            }
        }
    }
    
    private var questionsCount: some View {
        Text("\(swipeMode.questions.count) questions_count")
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
    }
    
    // MARK: Toolbar
    private var toolbarButtonAdd: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isPresentingNewQuestionSheet = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    private var toolbarButtonSort: some ToolbarContent {
        @Bindable var swipeMode = swipeMode
        
        return ToolbarItem(placement: .topBarTrailing) {
            Menu("menu_sort", systemImage: "arrow.up.arrow.down") {
                Picker("picker_sort_by", selection: $swipeMode.sortOption) {
                    ForEach(SwipeQuestion.SortOptions.allCases) { option in
                        Text(option.name)
                            .tag(option as SwipeQuestion.SortOptions)
                    }
                }
                Picker("picker_sort_order", selection: $swipeMode.sortOrder) {
                    Text("text_sort_ascending").tag(SortOrder.forward)
                    Text("text_sort_descending").tag(SortOrder.reverse)
                }
            }
        }
    }
    
    private var toolbarButtonFilter: some ToolbarContent {
        @Bindable var swipeMode = swipeMode
        
        return ToolbarItem(placement: .topBarTrailing) {
            Menu("menu_filter", systemImage: "line.3.horizontal.decrease") {
                Picker("picker_filter_by", selection: $swipeMode.filterOption) {
                    ForEach(SwipeQuestion.FilterOptions.allCases) { option in
                        Text(option.name)
                            .tag(option as SwipeQuestion.FilterOptions)
                    }
                }
            }
        }
    }
    
    // MARK: Actions
    private func onDelete(of question: SwipeQuestion) {
        swipeMode.questionToDelete = question
        isPresentingDeletionAlert = true
    }
}

#Preview {
    NavigationStack {
        SwipeQuestionsView()
    }
}
