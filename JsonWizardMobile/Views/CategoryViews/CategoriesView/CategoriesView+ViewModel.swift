//
//  CategoriesView+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 28/01/2025.
//

import Foundation

extension CategoriesView {
    
    @Observable
    class ViewModel {
        
        var isPresentingNewCategorySheet = false
        var isPresentingSignInSheet = false
        var errorWrapper: ErrorWrapper?
        var deletionIndexSet: IndexSet?
        var isPresentingDeletionAlert = false
        
        private(set) var isSet = false
        
        private var store = DataStore()
        
        var categories: [Category] {
            store.categories
        }
        
        var isCategoriesEmpty: Bool {
            categories.isEmpty
        }
        
        func set(store: DataStore) {
            self.store = store
            isSet = true
        }
        
        // MARK: Intents
        func presentNewCategorySheet() {
            isPresentingNewCategorySheet = true
        }
        
        func dismissNewCategorySheet() {
            isPresentingNewCategorySheet = false
        }
        
        func presentSignInSheet() {
            isPresentingSignInSheet = true
        }
        
        func dismissSignInSheet() {
            isPresentingSignInSheet = false
        }
        
        func presentDeletionAlert(for deletionIndexSet: IndexSet) {
            self.deletionIndexSet = deletionIndexSet
            isPresentingDeletionAlert = true
        }
        
        func dismissDeletionAlert() {
            deletionIndexSet = nil
        }
        
        func deleteCategories(with offsets: IndexSet) {
            let categoriesIDsToDelete = offsets.map { categories[$0].id }
            Task {
                do {
                    try store.delete(categories: categoriesIDsToDelete)
                } catch {
                    errorWrapper = .init(
                        error: error,
                        guidance: String(localized:"guidance_could_not_delete_categories_generic"),
                        isDismissable: true)
                }
            }
        }
    }
}
