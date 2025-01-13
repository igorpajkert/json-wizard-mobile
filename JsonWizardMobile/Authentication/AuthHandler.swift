//
//  AuthHandler.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import Foundation
import FirebaseAuth

/// A class responsible for handling user authentication using Firebase.
@Observable
class AuthHandler {
    
    /// The currently signed-in user, or `nil` if no user is signed in.
    var user: User?
    
    /// A listener handle that observes changes to the Firebase authentication state.
    private var handle: AuthStateDidChangeListenerHandle?
    
    /// Indicates whether a currently signed in uer is valid.
    var isUserValid: Bool {
        // TODO: User Roles
        user != nil
    }
    
    /// Initializes a new instance of `AuthHandler` and begins listening to authentication state changes.
    init() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.user = user
        }
    }
    
    /// Deinitializes the `AuthHandler`, removing the authentication state change listener.
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    /// Asynchronously signs in a user with the specified email and password.
    ///
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Throws: An error if the sign-in process fails (for example, invalid credentials).
    func signIn(with email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    /// Signs out the currently signed-in user.
    ///
    /// - Throws: An error if the sign-out process fails.
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
