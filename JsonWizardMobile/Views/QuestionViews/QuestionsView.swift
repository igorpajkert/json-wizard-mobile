//
//  QuestionsView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionsView: View {
    
    var questions: [Question]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(questions) { question in
                    NavigationLink(destination: QuestionEditView(question: question)) {
                        QuestionCardView(question: question)
                    }
                }
            }
            .listRowSpacing(10)
        }
        .navigationTitle("All Questions")
    }
}

#Preview("All Questions") {
    NavigationStack {
        QuestionsView(questions: Question.sampleData)
            .navigationTitle("All Questions")
    }
}
