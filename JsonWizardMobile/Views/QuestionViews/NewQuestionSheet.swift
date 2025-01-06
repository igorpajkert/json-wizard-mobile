//
//  NewQuestionSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct NewQuestionSheet: View {
    
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    var question: Question
    
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
    }
    
    // MARK: Toolbar
    private var toolbarSaveButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                withAnimation {
                    store.addQuestion(question)
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
    NewQuestionSheet(question: Question(id: 0))
}
