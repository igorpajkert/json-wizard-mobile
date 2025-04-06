//
//  SwipeMode+Collection.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/03/2025.
//

import Foundation

extension SwipeMode {
    
    var selectedCollection: CollectionType {
        get {
            currentCollection ?? .test
        }
        set {
            switchCollection(to: newValue)
        }
    }
    
    enum CollectionType : String, CaseIterable, Identifiable, Nameable {
        case development = "development_swipe_questions"
        case test = "test_swipe_questions"
        case production = "production_swipe_questions"
        
        var id: String { rawValue }
        
        var name: String {
            switch self {
            case .development:
                return "Development"
            case .test:
                return "Test"
            case .production:
                return "Production"
            }
        }
    }
    
    func getCollection() -> CollectionType? {
        guard let role = Authentication.shared.userData?.role else {
            return nil
        }
        
        switch role {
        case .admin:
            return .development
        case .creator:
            return .development
        case .guest:
            return .test
        default:
            return nil
        }
    }
    
    func setCollection() {
        if currentCollection == nil {
            currentCollection = getCollection()
        }
    }
    
    func switchCollection(to collection: CollectionType) {
        currentCollection = collection
        questions = []
        
        Task {
            await fetchData()
        }
        
        attachListener(to: collection)
    }
}
