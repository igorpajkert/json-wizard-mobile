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

        private let store: DataStore
        private let parentCategory: Category?

        init(store: DataStore, parentCategory: Category?) {
            self.store = store
            self.parentCategory = parentCategory
        }

        func saveQuestion(question: Question) {
            if let category = parentCategory {
                store.bind(category: category, with: question)
            }
            store.addQuestion(question)
        }
    }
}
