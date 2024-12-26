//
//  SampleData+Questions.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import Foundation

extension Question {
    /// Sample data for the question model.
    static let sampleData: [Question] = [
        .init(id: 0,
              questionText: "Which organ filters blood in the human body?",
              answers: [
                .init(id: 0, answerText: "Liver", isCorrect: true),
                .init(id: 1, answerText: "Kidneys"),
                .init(id: 2, answerText: "Lungs"),
                .init(id: 3, answerText: "Stomach")
              ]
             ),
        .init(id: 1,
              questionText: "What is the main function of red blood cells?",
              answers: [
                .init(id: 0, answerText: "Transport oxygen", isCorrect: true),
                .init(id: 1, answerText: "Fight infections")
              ]
             ),
        .init(id: 2,
              questionText: "What is the largest organ in the human body?")
    ]
}
