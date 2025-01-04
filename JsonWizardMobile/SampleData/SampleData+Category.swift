//
//  SampleData+Category.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import Foundation

extension Category {
    /// Sample data for the category model.
    static let sampleData: [Category] = [
        .init(id: 0,
              title: "General Knowledge",
              subtitle: "Everything you need to know!",
              questions: Question.sampleData,
              status: .done
             ),
        .init(id: 1,
              title: "First Aid",
              subtitle: "Quick actions, saved lives.",
              questions: Question.sampleData,
              status: .inProgress
             ),
        .init(id: 2,
              title: "Obesity",
              subtitle: "Understanding health and lifestyle.",
              status: .needsRework
             ),
        .init(id: 3,
              title: "Pharmacology Basics",
              subtitle: "Understand medicines and their effects.")
    ]
}
