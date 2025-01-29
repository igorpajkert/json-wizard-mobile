//
//  AnswersErrorBadge.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct AnswersErrorBadge: View {
    
    var answers: [Answer]
    
    private var corectAnswers: [Answer] { answers.filter(\.isCorrect) }
    
    private var image: String {
        answers.isEmpty || corectAnswers.isEmpty ? "exclamationmark.circle" : "checkmark.circle"
    }
    
    private var title: String {
        if answers.isEmpty {
            return String(localized: "text_no_answers")
        } else if corectAnswers.isEmpty {
            return String(localized: "text_no_correct_answers")
        } else {
            return ""
        }
    }
    
    private var color: Color {
        if answers.isEmpty {
            return .red
        } else if corectAnswers.isEmpty {
            return .yellow
        } else {
            return .green
        }
    }
    
    var body: some View {
        Label(title, systemImage: image)
            .labelStyle(.trailingIcon)
            .foregroundStyle(color)
    }
}

#Preview("Answers", traits: .fixedLayout(width: 400, height: 120)) {
    AnswersErrorBadge(answers: Question.sampleData[0].answersObject.answers)
}

#Preview("No Correct Answers", traits: .fixedLayout(width: 400, height: 120)) {
    AnswersErrorBadge(answers: Question.sampleData[1].answersObject.answers)
}

#Preview("No Answers", traits: .fixedLayout(width: 400, height: 120)) {
    AnswersErrorBadge(answers: Question.sampleData[2].answersObject.answers)
}
