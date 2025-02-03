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
        
        func refresh() async {
            do {
                try await store.refresh()
            } catch Authentication.AuthError.currentUserNotFound {
                errorWrapper = .init(
                    error: Authentication.AuthError.currentUserNotFound,
                    guidance: String(localized: "guidance_could_not_refresh_categories"),
                    isDismissable: true,
                    dismissAction: .init(
                        title: String(localized: "action_sign_in"),
                        action: presentSignInSheet
                    )
                )
            } catch {
                errorWrapper = .init(
                    error: error,
                    guidance: String(
                        localized: "guidance_could_not_refresh_categories_generic"
                    ),
                    isDismissable: true)
            }
        }
        
        func deleteCategories(with offsets: IndexSet) {
            let categoriesIDsToDelete = offsets.map { categories[$0].id }
            store.delete(categories: categoriesIDsToDelete)
        }
    }
}
