//
//  DataStore+Collection.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/02/2025.
//

import Foundation

extension DataStore {
    
    enum Collection: String, CaseIterable, Identifiable, Nameable {
        case devCategories = "development_categories"
        case devQuestions = "development_questions"
        case testCategories = "test_categories"
        case testQuestions = "test_questions"
        case prodCategories = "production_categories"
        case prodQuestions = "production_questions"
        
        var id: String { rawValue }
        
        var name: String {
            switch self {
            case .devCategories:
                return "Categories Development"
            case .devQuestions:
                return "Questions Development"
            case .testCategories:
                return "Categories Test"
            case .testQuestions:
                return "Questions Test"
            case .prodCategories:
                return "Categories Production"
            case .prodQuestions:
                return "Questions Production"
            }
        }
    }
    
    enum CollectionType: String, CaseIterable, Identifiable, Nameable {
        case development = "Development"
        case test = "Test"
        case production = "Production"
        
        var id: String { rawValue }
        
        var name: String { rawValue }
    }
    
    /// Switches the current collection environment.
    func switchCollection(to collection: CollectionType) {
        changeCollection(to: collection)
        changeData(to: collection)
    }
    
    private func changeCollection(to collection: CollectionType) {
        currentCollectionType = collection
        
        switch collection {
        case .development:
            currentCollection.categories = .devCategories
            currentCollection.questions = .devQuestions
            
        case .test:
            currentCollection.categories = .testCategories
            currentCollection.questions = .testQuestions
            
        case .production:
            currentCollection.categories = .prodCategories
            currentCollection.questions = .prodQuestions
        }
    }
    
    private func changeData(to collection: CollectionType) {
        fetchData(for: collection)
        attachListeners(to: collection)
    }
}
