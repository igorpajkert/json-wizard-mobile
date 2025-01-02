//
//  QuestionCardView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionCardView: View {
    
    var question: Question
    
    var categories: [Category] {
        guard let categories = question.categories else { return [] }
        return categories
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question.questionText)
                .font(.headline)
            HStack {
                ForEach(categories) { category in
                    CategoryBadge(category: category)
                }
            }
            Spacer()
            HStack {
                Label("\(question.answersCount) Answers", systemImage: "mail.stack")
                Spacer()
                AnswersErrorBadge(answers: question.answers)
            }
            .font(.callout)
        }
        .padding(.vertical)
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
