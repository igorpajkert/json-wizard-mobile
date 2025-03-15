//
//  DataStore+Migration.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 02/03/2025.
//

import Foundation

extension DataStore {
    
    enum MigrationError: Error, LocalizedError {
        case categoryNotFound
    }
    
    func migrate(category id: Int, to collection: CollectionType) async throws {
        guard let category = getCategory(with: id) else {
            throw MigrationError.categoryNotFound
        }
        let questions = getQuestions(with: category.questionIDs)
        try await copy(data: (category: category, questions: questions), to: collection)
        if collection == .production {
            category.setProductionTransferDate(to: .now)
            try update(category: category, shouldUpdateDate: false)
        }
    }
    
    private func copy(data: (category: Category, questions: [Question]), to collection: CollectionType) async throws {
        let collectionNames = getCollectionNames(for: collection)
        try await withThrowingTaskGroup(of: Void.self) { group in
            // Migrate the category
            group.addTask {
                let _ = try await self.database.setData(
                    data.category,
                    in: data.category.id.toString(),
                    within: collectionNames.categories,
                    merge: true
                )
            }
            
            // Migrate all questions concurrently
            for question in data.questions {
                group.addTask {
                    let _ = try await self.database.setData(
                        question,
                        in: question.id.toString(),
                        within: collectionNames.questions,
                        merge: true
                    )
                }
            }
            try await group.waitForAll()
        }
    }
}
