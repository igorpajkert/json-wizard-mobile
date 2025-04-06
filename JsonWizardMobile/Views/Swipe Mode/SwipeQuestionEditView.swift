//
//  SwipeQuestionEditView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 25/03/2025.
//

import SwiftUI

struct SwipeQuestionEditView: View {
    
    @State private var text = ""
    @State private var isCorrect = false
    @State private var isPresentingDeletionAlert = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.swipeMode) private var swipeMode
    
    @FocusState private var isTextFieldFocused: Bool
    
    var question: SwipeQuestion
    
    var isModified: Bool {
        text != question.text || isCorrect != question.isCorrect
    }
    
    var body: some View {
        Form {
            Section("section_question") {
                textFieldQuestion
                ToggleIsCorrect(isOn: $isCorrect)
                textDateCreated
                textDateModified
            }
        }
        .navigationTitle("title_edit_question")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarButtonDelete
            KeyboardButtonDone(isFocused: isTextFieldFocused) {
                isTextFieldFocused = false
            }
        }
        .alert(
            "alert_title_swipe_question_delete",
            isPresented: $isPresentingDeletionAlert,
            actions: {
                Button("button_delete", role: .destructive) {
                    swipeMode.deleteQuestion()
                    dismiss()
                }
                Button("button_cancel", role: .cancel) {
                    swipeMode.questionToDelete = nil
                }
            }, message: {
                Text("message_delete_swipe_question_confirmation")
            })
        .onAppear {
            text = question.text
            isCorrect = question.isCorrect
        }
        .onDisappear {
            if isModified {
                question.text = text
                question.isCorrect = isCorrect
                
                swipeMode.updateQuestion(question)
            }
        }
    }
    
    private var textFieldQuestion: some View {
        TextField("text_field_question", text: $text, axis: .vertical)
            .focused($isTextFieldFocused)
    }
    
    private var textDateCreated: some View {
        HStack {
            Text("text_created")
            Spacer()
            Text(
                question.dateCreated,
                format: .dateTime.day().month().year().hour().minute()
            )
            .foregroundStyle(.secondary)
        }
    }
    
    private var textDateModified: some View {
        HStack {
            Text("text_modified")
            Spacer()
            Text(
                question.dateModified,
                format: .dateTime.day().month().year().hour().minute()
            )
            .foregroundStyle(.secondary)
        }
    }
    
    // MARK: Toolbar
    private var toolbarButtonDelete: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                onDelete(of: question)
            } label: {
                Image(systemName: "trash")
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
        SwipeQuestionEditView(question: SwipeQuestion())
    }
}
