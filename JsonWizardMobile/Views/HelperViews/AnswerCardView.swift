//
//  AnswerCardView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 28/12/2024.
//

import SwiftUI

struct AnswerCardView: View {
    
    private let keys = (
        correct: String(localized: "text_correct"),
        incorrect: String(localized: "text_incorrect")
    )
    
    private var title: String {
        answer.isCorrect ? keys.correct : keys.incorrect
    }
    
    private var image: String {
        answer.isCorrect ? "checkmark" : "xmark"
    }
    
    private var color: Color {
        answer.isCorrect ? .green : .red
    }
    
    @Bindable var answer: Answer
    
    var body: some View {
        VStack {
            TextField("Answer Text", text: $answer.answerText, axis: .vertical)
            Spacer()
            Toggle(isOn: $answer.isCorrect) {
                Label(title, systemImage: image)
                    .foregroundStyle(color)
                    .contentTransition(.symbolEffect(.replace))
                    .animation(.default, value: answer.isCorrect)
                    .font(.callout)
                    .bold()
            }
            .tint(.accent)
        }
        .padding(.vertical)
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 120)) {
    AnswerCardView(answer: Question.sampleData[0].answersObject.answers[0])
}
