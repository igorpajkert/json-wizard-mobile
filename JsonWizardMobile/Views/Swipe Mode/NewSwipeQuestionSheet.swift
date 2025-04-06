//
//  NewSwipeQuestionSheet.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 25/03/2025.
//

import SwiftUI

struct NewSwipeQuestionSheet: View {
    
    @State private var text = ""
    @State private var isCorrect = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.swipeMode) private var swipeMode
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("section_question") {
                    textFieldQuestion
                    ToggleIsCorrect(isOn: $isCorrect)
                }
                Section {
                    HStack {
                        Spacer()
                        buttonAdd
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("title_add_swipe_question")
            .toolbar {
                ToolbarButtonAdd(disabled: text.isEmpty) {
                    addQuestion()
                    dismiss()
                }
                ToolbarButtonCancel {
                    dismiss()
                }
                KeyboardButtonDone(isFocused: isTextFieldFocused) {
                    isTextFieldFocused = false
                }
            }
        }
    }
    
    private var textFieldQuestion: some View {
        TextField("text_field_question", text: $text, axis: .vertical)
            .focused($isTextFieldFocused)
    }
    
    private var buttonAdd: some View {
        Button {
            addQuestion()
            dismiss()
        } label: {
            Text("button_add")
                .padding(8)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .disabled(text.isEmpty)
    }
    
    // MARK: Actions
    private func addQuestion() {
        swipeMode.addQuestion(with: text, isCorrect: isCorrect)
    }
}

#Preview {
    NewSwipeQuestionSheet()
}
