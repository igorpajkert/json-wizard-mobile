//
//  NewQuestionSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import SwiftUI

struct NewQuestionSheet: View {
    var question: Question
    @Environment(\.store) private var store
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            QuestionEditView(question: question)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
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
        }
    }
}

#Preview {
    NewQuestionSheet(question: Question(id: 0))
}
