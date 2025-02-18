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
        var errorWrapper: ErrorWrapper?
        
        private(set) var isSet = false
        
        private var store = DataStore()
        private var parentCategory: Category? = nil
        
        func set(store: DataStore, parentCategory: Category?) {
            self.store = store
            self.parentCategory = parentCategory
            isSet = true
        }
        
        func saveQuestion() {
            do {
                if let category = parentCategory {
                    try store.bind(
                        category: category,
                        with: question,
                        shouldUpdate: true
                    )
                }
                try store.update(question: question)
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(
                        localized: "guidance_saving_question_failed_generic"
                    ),
                    isDismissable: true
                )
            }
        }
        
        func cleanUpBindings() {
            store.cleanUpBindings()
        }
    }
}
