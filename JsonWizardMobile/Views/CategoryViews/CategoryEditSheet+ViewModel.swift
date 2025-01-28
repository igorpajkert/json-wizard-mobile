//
//  CategoryEditSheet+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 28/01/2025.
//

import SwiftUI

extension CategoryEditSheet {
    
    @Observable
    class ViewModel {
        
        var category: Category? = nil
        var editedCategory = Category()
        
        private(set) var isSet = false
        
        private var store = DataStore()
        private let editorTitleKeys = (
            edit: String(localized: "title_edit_category"),
            add: String(localized: "title_add_category")
        )
        
        var editorTitle: String {
            category != nil ? editorTitleKeys.edit : editorTitleKeys.add
        }
                
        func set(category: Category?, store: DataStore) {
            self.category = category
            self.store = store
            
            if let category = category {
                editedCategory = category
            }
            
            isSet = true
        }
        
        func save() {
            if category == nil {
                store.addCategory(editedCategory)
            }
        }
    }
}
