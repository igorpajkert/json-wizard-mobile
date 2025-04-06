//
//  SwipeMode.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/03/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class SwipeMode {
    
    var selectedQuestion: SwipeQuestion?
    var questionToDelete: SwipeQuestion?
    var errorWrapper: ErrorWrapper?
    
    var searchText = ""
    var sortOrder = SortOrder.forward
    var sortOption = SwipeQuestion.SortOptions.recent
    var filterOption = SwipeQuestion.FilterOptions.none
    
    var questions = [SwipeQuestion]()
    
    var currentCollection: CollectionType?
    var listener: ListenerRegistration?
    
    init(
        questions: [SwipeQuestion] = [SwipeQuestion]()
    ) {
        self.questions = questions
    }
}
