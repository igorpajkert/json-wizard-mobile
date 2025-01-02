//
//  DataStore.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import Foundation

@Observable
class DataStore {
    
    var categories = [Category]()
    var questions = [Question]()
    
    init(categories: [Category] = [Category](), questions: [Question] = Question.sampleData) {
        self.categories = categories
        self.questions = questions
    }
}
