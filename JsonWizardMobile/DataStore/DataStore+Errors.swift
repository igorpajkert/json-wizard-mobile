//
//  DataStore+Errors.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/01/2025.
//

import Foundation

// MARK: Errors
extension DataStore {
    
    // TODO: Errors Handling
    enum StoreError: Error, LocalizedError {
        case categoryAlreadyAttached
        case questionAlreadyAttached
        case categoryNotFound
        case questionNotFound
        
        public var errorDescription: String? {
            switch self {
            case .categoryAlreadyAttached: return String(localized: "error_category_already_attached")
            case .questionAlreadyAttached: return String(localized: "error_question_already_attached")
            case .categoryNotFound: return String(localized: "error_category_not_found")
            case .questionNotFound: return String(localized: "error_question_not_found")
            }
        }
    }
}
