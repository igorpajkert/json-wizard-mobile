//
//  NewQuestionSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct NewQuestionSheet: View {

    @State private var viewModel: NewQuestionSheet.ViewModel?
    @State private var question = Question()

    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss

    var parentCategory: Category?

    var body: some View {
        NavigationStack {
            QuestionEditView(
                question: question,
                parentCategory: parentCategory
            )
            .navigationTitle("Add Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarSaveButton
                toolbarCancelButton
            }
        }
        .onAppear {
            viewModel = .init(store: store, parentCategory: parentCategory)
        }
    }

    // MARK: Toolbar
    private var toolbarSaveButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                withAnimation {
                    viewModel?.saveQuestion(question: question)
                    dismiss()
                }
            }
            .disabled(question.questionText.isEmpty)
        }
    }

    private var toolbarCancelButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
    }
}

#Preview {
    NewQuestionSheet()
}
