//
//  Authentication+Errors.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/01/2025.
//

import Foundation

// MARK: Errors
extension Authentication {
    
    /// Custom authentication error codes.
    public enum AuthError: Error, LocalizedError {
        /// Indicates that there is no currently authenticated user.
        case currentUserNotFound
        /// Indicates that currently authenticated user is not a valid developer account.
        case invalidUser
        /// Indicates that reauthentication is required for the current user session.
        case reauthenticationRequired
        
        public var errorDescription: String? {
            switch self {
            case .currentUserNotFound: return String(localized: "error_current_user_not_found")
            case .invalidUser: return String(localized: "error_invalid_user")
            case .reauthenticationRequired: return String(localized: "error_reauthentication_required")
            }
        }
    }
}
