//
//  CategoryDetailView+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/02/2025.
//

import Foundation

extension CategoryDetailView {
    
    @Observable
    class ViewModel {
        
        var isPresentingEditCategorySheet = false
        var category = Category()
        
        private(set) var isSet = false
        private var store = DataStore()
        
        var categoryQuestions: [Question] {
            store.getQuestions(of: category.questionIDs)
        }
        
        func set(store: DataStore, category: Category) {
            self.store = store
            self.category = category
            isSet = true
        }
        
        // MARK: Intents
        func presentEditViewSheet() {
            isPresentingEditCategorySheet = true
        }
        
        func dismissEditViewSheet() {
            isPresentingEditCategorySheet = false
        }
    }
}
