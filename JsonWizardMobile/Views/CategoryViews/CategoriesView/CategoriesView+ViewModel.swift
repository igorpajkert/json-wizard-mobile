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
        
        var searchText = ""
        var sortOrder = SortOrder.forward
        var sortOption = Category.SortOptions.recent
        var filterOption = Category.FilterOptions.none
        var selectedStatus = Status.draft
        
        var isPresentingDeletionAlert = false
        private var categoryToDelete: Category?
        
        private var isSet = false
        private var store = DataStore()
        
        var isAdmin: Bool {
            Authentication.shared.userData?.role == .admin
        }
        
        var currentCollectionType: DataStore.CollectionType {
            get {
                store.currentCollectionType
            }
            set {
                store.switchCollection(to: newValue)
            }
        }
        
        var isCategoriesEmpty: Bool {
            categories.isEmpty
        }
        
        var categories: [Category] {
            var result = store.categories
            
            // Filter questions based on the search text
            if !searchText.isEmpty {
                result = result.filter {
                    $0.title.localizedStandardContains(searchText)
                }
            }
            
            // Apply filtering based on the filterOption
            switch filterOption {
            case .none:
                break
            case .status:
                switch selectedStatus {
                case .done:
                    result = result.filter { $0.status == .done }
                case .inProgress:
                    result = result.filter { $0.status == .inProgress }
                case .draft:
                    result = result.filter { $0.status == .draft }
                case .needsRework:
                    result = result.filter { $0.status == .needsRework }
                }
            case .withQuestions:
                result = result.filter { $0.questionsCount > 0 }
            case .withoutQuestions:
                result = result.filter { $0.questionsCount == 0 }
            }
            
            // Apply sorting based on the sortOption
            switch sortOption {
            case .recent:
                result.sort { $0.dateCreated > $1.dateCreated }
            case .alphabetical:
                result.sort { $0.title < $1.title }
            case .questionsCount:
                result.sort { $0.questionsCount > $1.questionsCount }
            }
            
            // Reverse the order if sortOrder is descending
            if sortOrder == .reverse {
                result.reverse()
            }
            
            return result
        }
        
        func set(store: DataStore) {
            guard isSet == false else { return }
            self.store = store
            isSet = true
        }
        
        // MARK: - Intents
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
        
        private func presentDeletionAlert(for category: Category) {
            categoryToDelete = category
            isPresentingDeletionAlert = true
        }
        
        private func dismissDeletionAlert() {
            categoryToDelete = nil
        }
        
        private func deleteCategory() {
            guard let categoryToDelete = categoryToDelete else { return }
            Task {
                do {
                    let ids = [categoryToDelete.id]
                    try store.delete(categories: ids)
                } catch {
                    errorWrapper = .init(
                        error: error,
                        guidance: String(localized:"guidance_could_not_delete_categories_generic"),
                        isDismissable: true)
                }
            }
        }
        
        // MARK: - Events
        func onDelete(_ category: Category) {
            presentDeletionAlert(for: category)
        }
        
        func onDeleteConfirmation() {
            deleteCategory()
        }
        
        func onDeleteCancelation() {
            dismissDeletionAlert()
        }
    }
}
