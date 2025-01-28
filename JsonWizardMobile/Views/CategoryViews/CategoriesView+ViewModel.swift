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
        
        private(set) var isSet = false
        
        private var store: DataStore
        
        var categories: [Category] {
            store.categoriesObject.categories
        }
        
        var isCategoriesEmpty: Bool {
            categories.isEmpty
        }
        
        init(store: DataStore = DataStore()) {
            self.store = store
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
        
        func refresh() async {
            do {
                try await store.refresh()
            } catch Authentication.AuthError.invalidUser {
                errorWrapper = .init(
                    error: Authentication.AuthError.invalidUser,
                    guidance: "Could not refresh categories. Sign in to continue.",
                    isDismissable: true,
                    dismissAction: .init(title: "Sign In", action: presentSignInSheet))
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance:
                        "Could not refresh categories. Check if you are properly signed in and try again.",
                    isDismissable: true)
            }
        }
        
        func deleteCategories(with offsets: IndexSet) {
            let categoriesIDsToDelete = offsets.map { categories[$0].id }
            store.delete(categories: categoriesIDsToDelete)
        }
    }
}
