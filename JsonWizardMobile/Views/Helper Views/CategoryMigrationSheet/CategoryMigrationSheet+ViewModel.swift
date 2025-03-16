//
//  CategoryMigrationSheet+ViewModel.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 02/03/2025.
//

import Foundation

extension CategoryMigrationSheet {
    
    @Observable
    class ViewModel {
        
        var category = Category()
        var selection = DataStore.CollectionType.production
        var errorWrapper: ErrorWrapper?
        
        private var isSet = false
        private var store = DataStore()
        
        var allowedSelection: [DataStore.CollectionType] {
            DataStore.CollectionType.allCases.filter {
                $0 != currentCollection
            }
        }
        
        var currentCollection: DataStore.CollectionType {
            store.currentCollectionType
        }
        
        var lastProductionTransfer: Date? {
            category.productionTransferDate
        }
        
        var needsUpdate: Bool {
            category.needsUpdate
        }
        
        func set(category: Category, store: DataStore) {
            guard isSet == false else { return }
            self.category = category
            self.store = store
            isSet = true
        }
        
        // MARK: - Intents
        func migrate() {
            Task {
                do {
                    try await store.migrate(category: category.id, to: selection)
                } catch {
                    errorWrapper = .init(
                        error: error,
                        guidance: String(
                            localized: "guidance_failed_to_migrate_category"
                        ),
                        isDismissable: true)
                }
            }
        }
        
        // MARK: - Events
        func onMigrateTapped() {
            migrate()
        }
    }
}
