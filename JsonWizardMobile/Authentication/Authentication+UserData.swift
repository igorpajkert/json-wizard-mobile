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
        userData = try await database.getData(from: user.uid, within: "user_data")
    }
}
