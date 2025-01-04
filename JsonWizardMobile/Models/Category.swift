//
//  Category.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation
import SwiftUI

/// Model class that defines properties for a question category.
@Observable
final class Category: Codable, Identifiable {
    var id: Int
    var title: String
    var subtitle: String?
    var questions: [Question]
    var status: Status
    var color: Color?
    var dateCreated: Date
    
    var questionsCount: Int { questions.count }
    
    init(id: Int, title: String = "", subtitle: String? = nil, questions: [Question] = [], status: Status = .draft, color: Color? = nil, dateCreated: Date = .now) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.questions = questions
        self.status = status
        self.color = color
        self.dateCreated = dateCreated
    }
}
