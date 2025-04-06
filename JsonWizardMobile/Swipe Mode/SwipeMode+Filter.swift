//
//  SwipeMode+Filter.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 07/04/2025.
//

import Foundation

extension SwipeMode {
    
    var filteredQuestions: [SwipeQuestion] {
        var result = questions
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.text.localizedStandardContains(searchText)
            }
        }
        
        switch filterOption {
        case .none:
            break
        case .correct:
            result = result.filter { $0.isCorrect }
        case .incorrect:
            result = result.filter { !$0.isCorrect }
        }
        
        switch sortOption {
        case .recent:
            result.sort { $0.dateCreated > $1.dateCreated }
        case .alphabetical:
            result.sort { $0.text < $1.text }
        }
        
        if sortOrder == .reverse {
            result.reverse()
        }
        
        return result
    }
}
