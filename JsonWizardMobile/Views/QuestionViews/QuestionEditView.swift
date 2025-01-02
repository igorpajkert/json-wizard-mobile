//
//  QuestionEditView.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI

struct QuestionEditView: View {
    
    var categories: [Category] {
        guard let categories = question.categories else { return [] }
        return categories
    }
    
    @State private var newAnswerText = ""
    @Environment(\.store) private var store
    @Bindable var question: Question
    
    var body: some View {
        List {
            Section("Question") {
                TextField("Question Text", text: $question.questionText, axis: .vertical)
                HStack {
                    HStack {
                        ForEach(categories) { category in
                            CategoryBadge(category: category)
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus.circle")
                    }
                }
                Text("Created \(question.dateCreated.formatted(date: .long, time: .shortened))")
                    .frame(maxWidth: .infinity)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            }
            Section("Answers") {
                ForEach(question.answers) { answer in
                    AnswerCardView(answer: answer)
                }
                HStack {
                    TextField("Add Answer...", text: $newAnswerText, axis: .vertical)
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newAnswerText.isEmpty)
                }
                Text("\(question.answersCount) answers, \(question.correctAnswersCount) correct")
                    .frame(maxWidth: .infinity)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
        .listRowSpacing(10)
    }
}

#Preview {
    QuestionEditView(question: Question.sampleData[0])
}
