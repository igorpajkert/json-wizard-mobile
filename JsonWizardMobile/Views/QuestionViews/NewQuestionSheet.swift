//
//  NewQuestionSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct NewQuestionSheet: View {
    
    @State private var question = Question(id: 0)
    @State private var isQuestionAdded = false
    
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    var parentCategory: Category?
    
    var body: some View {
        NavigationStack {
            QuestionEditView(question: question)
                .navigationTitle("Add Question")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarSaveButton
                    toolbarCancelButton
                }
        }
        .onAppear {
            question = store.createEmptyQuestion(in: parentCategory)
        }
        .onDisappear {
            if !isQuestionAdded {
                store.unbindAll(from: question)
            }
        }
    }
    
    // MARK: Toolbar
    private var toolbarSaveButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                withAnimation {
                    store.addQuestion(question)
                    isQuestionAdded = true
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
