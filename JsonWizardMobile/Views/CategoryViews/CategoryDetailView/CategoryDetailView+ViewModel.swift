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
        var isPresentingMigrationSheet = false
        var categoryID = 0
        
        private(set) var isSet = false
        private var store = DataStore()
        
        var category: Category {
            store.getCategory(with: categoryID) ?? Category()
        }
        
        var categoryQuestions: [Question] {
            store.getQuestions(with: category.questionIDs)
        }
        
        var lastProductionTransfer: Date? {
            category.productionTransferDate
        }
        
        var needsUpdate: Bool {
            category.needsUpdate
        }
        
        var isNotProduction: Bool {
            store.currentCollectionType != .production
        }
        
        var isAdmin: Bool {
            Authentication.shared.userData?.role == .admin
        }
        
        func set(store: DataStore, category: Category) {
            self.store = store
            self.categoryID = category.id
            isSet = true
        }
        
        // MARK: Intents
        func presentEditViewSheet() {
            isPresentingEditCategorySheet = true
        }
        
        func dismissEditViewSheet() {
            isPresentingEditCategorySheet = false
        }
        
        private func presentMigrationSheet() {
            isPresentingMigrationSheet = true
        }
        
        private func dismissMigrationSheet() {
            isPresentingMigrationSheet = false
        }
        
        // MARK: - Events
        func onMigrateTapped() {
            presentMigrationSheet()
        }
        
        func onMigrateDismissed() {
            dismissMigrationSheet()
        }
    }
}
