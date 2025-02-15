//
//  CategoriesPickerSheet+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 03/02/2025.
//

import Foundation

extension CategoriesPickerSheet {
    
    @Observable
    class ViewModel {
        
        var store = DataStore()
        
        var question = Question()
        var parentCategory: Category?
        var errorWrapper: ErrorWrapper?
        
        private(set) var isSet = false
        
        var categories: [Category] {
            store.categories
        }
        
        func set(
            store: DataStore,
            question: Question,
            parentCategory: Category?
        ) {
            self.store = store
            self.question = question
            self.parentCategory = parentCategory
            isSet = true
        }
        
        func image(for category: Category) -> String {
            let isBound = store.isBound(category: category, with: question)
            if isBound || category == parentCategory {
                return "checkmark.circle.fill"
            } else {
                return "circle"
            }
        }
        
        func bind(category: Category) {
            let isBound = store.isBound(category: category, with: question)
            do {
                if isBound {
                    try store.unbind(category: category, from: question)
                } else {
                    try store.bind(category: category, with: question)
                }
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(localized: "guidance_unable_to_bind_category_generic"),
                    isDismissable: true)
            }
        }
    }
}
