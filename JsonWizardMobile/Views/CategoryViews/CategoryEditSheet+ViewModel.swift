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
        var title = ""
        var subtitle = ""
        var status = Status.draft
        var color = Color.accent
        var dateCreated = Date.now
        
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
                title = category.title
                subtitle = category.subtitle ?? ""
                status = category.status
                color = category.color ?? .accent
                dateCreated = category.dateCreated
            }
            
            isSet = true
        }
        
        func save() {
            if let category = category {
                category.title = title
                category.subtitle = subtitle
                category.status = status
                category.color = color
            } else {
                let newCategory = Category(
                    title: title,
                    subtitle: subtitle,
                    status: status,
                    color: color
                )
                store.addCategory(newCategory)
            }
        }
    }
}
