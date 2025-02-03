//
//  NewQuestionSheet+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 23/01/2025.
//

import Foundation

extension NewQuestionSheet {
    
    @Observable
    class ViewModel {
        
        var question = Question()
        
        private(set) var isSet = false
        
        private var store = DataStore()
        private var parentCategory: Category? = nil
        
        func set(store: DataStore, parentCategory: Category?) {
            self.store = store
            self.parentCategory = parentCategory
            isSet = true
        }
        
        func saveQuestion() {
            if let category = parentCategory {
                store.bind(category: category, with: question)
            }
            store.addQuestion(question)
        }
    }
}
