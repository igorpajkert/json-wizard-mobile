//
//  DataStore.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 26/12/2024.
//

import Foundation
import FirebaseFirestore

/// A data store that manages categories and questions.
@Observable
final class DataStore {
    
    let database = DatabaseController()
    
    var categories: [Category]
    var questions: [Question]
    
    var currentCollectionType = CollectionType.development
    var currentCollection = (
        categories: Collection.devCategories,
        questions: Collection.devQuestions
    )
    
    var categoriesListener: ListenerRegistration? = nil
    var questionsListener: ListenerRegistration? = nil
    
    init(
        categories: [Category] = [],
        questions: [Question] = []
    ) {
        self.categories = categories
        self.questions = questions
        
        fetchData(from: currentCollectionType)
        attachListeners(to: currentCollectionType)
    }
    
    deinit {
        detachListeners()
    }
}
