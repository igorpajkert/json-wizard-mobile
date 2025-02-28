//
//  NewQuestionSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct NewQuestionSheet: View {
    
    @State private var viewModel = NewQuestionSheet.ViewModel()
    
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    var parentCategory: Category?
    
    var body: some View {
        NavigationStack {
            QuestionEditView(
                question: viewModel.question,
                parentCategory: parentCategory,
                viewType: .new
            )
            .navigationTitle("Add Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarSaveButton
                toolbarCancelButton
            }
            .sheet(item: $viewModel.errorWrapper) { wrapper in
                ErrorSheet(errorWrapper: wrapper)
            }
            .onAppear {
                if !viewModel.isSet {
                    viewModel.set(
                        store: store,
                        parentCategory: parentCategory
                    )
                }
            }
        }
    }
    
    // MARK: Toolbar
    private var toolbarSaveButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                withAnimation {
                    viewModel.saveQuestion()
                    dismiss()
                }
            }
            .disabled(viewModel.question.questionText.isEmpty)
        }
    }
    
    private var toolbarCancelButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel) {
                viewModel.cleanUpBindings()
                dismiss()
            }
        }
    }
}

#Preview {
    NewQuestionSheet()
}
