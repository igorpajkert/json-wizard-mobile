//
//  SwipeQuestionCard.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 25/03/2025.
//

import SwiftUI

struct SwipeQuestionCard: View {
    
    let question: SwipeQuestion
    
    var text: LocalizedStringKey {
        question.isCorrect ? "label_correct" : "label_incorrect"
    }
    
    var image: String {
        question.isCorrect ? "checkmark.circle" : "xmark.circle"
    }
    
    var color: Color {
        question.isCorrect ? .green : .red
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question.text)
                .font(.headline)
            Spacer()
            HStack {
                label
                Spacer()
            }
        }
        .padding(.vertical)
    }
    
    var label: some View {
        Label(text, systemImage: image)
            .padding(.trailing)
            .foregroundStyle(color.adaptedTextColor())
            .background {
                RoundedRectangle(cornerRadius: 32)
                    .fill(color)
            }
            .shadow(radius: 2)
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 200)) {
    SwipeQuestionCard(
        question: .init(
            text: "Test Question",
            isCorrect: false,
            dateCreated: .distantPast,
            dateModified: .now
        )
    )
}
