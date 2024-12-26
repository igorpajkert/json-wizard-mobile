//
//  Category.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation

/// Model class that defines properties for a question category.
@Observable
final class Category: Codable {
    var title: String
    var subtitle: String?
    var questions: [Question]
    var status: Status
    var dateCreated: Date
    
    var questionsCount: Int { questions.count }
    
    init(title: String = "", subtitle: String? = nil, questions: [Question] = [], status: Status = .draft, dateCreated: Date = .now) {
        self.title = title
        self.subtitle = subtitle
        self.questions = questions
        self.status = status
        self.dateCreated = dateCreated
    }
}
