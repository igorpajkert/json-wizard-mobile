//
//  Authentication+UserData.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 01/02/2025.
//

import Foundation

extension Authentication {
    
    /// Fetches user data asynchronously from the database.
    func fetchUserData() async throws {
        guard let user = user else {
            userData = nil
            throw AuthError.currentUserNotFound
        }
        let database = DatabaseController()
        userData = try await database.getData(from: user.uid, within: "user_data_test")
    }
    
    func isUserValid() -> Bool {
        Task {
            try? await fetchUserData()
        }
        
        guard let userData = userData else { return false }
        
        switch userData.role {
        case .admin: return true
        case .creator: return true
        case .guest: return true
        case .user: return false
        default: return false
        }
    }
    
    func isAdmin() -> Bool {
        Task {
            try? await fetchUserData()
        }
        
        guard let userData = userData else { return false }
        
        if userData.role == .admin {
            return true
        } else {
            return false
        }
    }
}
