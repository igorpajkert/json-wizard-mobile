//
//  DataStore+Fetch.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/02/2025.
//

import Foundation

extension DataStore {
    
    func fetchData(from collection: CollectionType) {
        switch collection {
        case .development:
            fetchDevelopmentData()
            
        case .test:
            fetchTestData()
            
        case .production:
            fetchProductionData()
        }
    }
    
    private func fetchDevelopmentData() {
        Task {
            do {
                let devCategories: [Category] = try await database.getAllDocuments(
                    from: DataStore.Collection.devCategories.rawValue
                )
                let devQuestions: [Question] = try await database.getAllDocuments(
                    from: DataStore.Collection.devQuestions.rawValue
                )
                categories = devCategories
                questions = devQuestions
            } catch {
                print("Failed to fetch development data: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchTestData() {
        Task {
            do {
                let testCategories: [Category] = try await database.getAllDocuments(
                    from: DataStore.Collection.testCategories.rawValue
                )
                let testQuestions: [Question] = try await database.getAllDocuments(
                    from: DataStore.Collection.testQuestions.rawValue
                )
                categories = testCategories
                questions = testQuestions
            } catch {
                print("Failed to fetch test data: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchProductionData() {
        Task {
            do {
                let prodCategories: [Category] = try await database.getAllDocuments(
                    from: DataStore.Collection.prodCategories.rawValue
                )
                let prodQuestions: [Question] = try await database.getAllDocuments(
                    from: DataStore.Collection.prodQuestions.rawValue
                )
                categories = prodCategories
                questions = prodQuestions
            } catch {
                print("Failed to fetch production data: \(error.localizedDescription)")
            }
        }
    }
}
