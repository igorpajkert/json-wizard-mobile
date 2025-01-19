//
//  QuestionCardView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionCardView: View {
    
    var question: Question
    
    var body: some View {
        VStack(alignment: .leading) {
            textAndCategories
            Spacer()
            answersCountAndErrorBadge
        }
        .padding(.vertical)
    }
    
    private var textAndCategories: some View {
        Group {
            Text(question.questionText)
                .font(.headline)
            HStack {
                ForEach(question.unwrappedCategories) { category in
                    CategoryBadge(category: category)
                }
            }
        }
    }
    
    private var answersCountAndErrorBadge: some View {
        HStack {
            Label("\(question.answersCount) answers_count", systemImage: "mail.stack")
            Spacer()
            AnswersErrorBadge(answers: question.answers)
        }
        .font(.callout)
    }
}

#Preview("Answers", traits: .fixedLayout(width: 400, height: 120)) {
    QuestionCardView(question: Question.sampleData[0])
}

#Preview("No Correct Answers", traits: .fixedLayout(width: 400, height: 120)) {
    QuestionCardView(question: Question.sampleData[1])
}

#Preview("No Answers", traits: .fixedLayout(width: 400, height: 120)) {
    QuestionCardView(question: Question.sampleData[2])
}
