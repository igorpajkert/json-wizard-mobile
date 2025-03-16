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
        
        private var viewType: QuestionViewType = .new
        
        var categories: [Category] {
            store.categories
        }
        
        func set(
            store: DataStore,
            question: Question,
            parentCategory: Category?,
            viewType: QuestionViewType
        ) {
            self.store = store
            self.question = question
            self.parentCategory = parentCategory
            self.viewType = viewType
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
        
        private func bind(category: Category, shouldUpdate: Bool) {
            let isBound = store.isBound(category: category, with: question)
            do {
                if isBound {
                    try store.unbind(
                        category: category,
                        from: question,
                        shouldUpdate: shouldUpdate
                    )
                } else {
                    try store.bind(
                        category: category,
                        with: question,
                        shouldUpdate: shouldUpdate
                    )
                }
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(
                        localized: "guidance_unable_to_bind_category_generic"
                    ),
                    isDismissable: true)
            }
        }
        
        func onCategorySelected(_ category: Category) {
            switch viewType {
            case .edit:
                bind(category: category, shouldUpdate: true)
            case .new:
                bind(category: category, shouldUpdate: false)
            }
        }
    }
}
