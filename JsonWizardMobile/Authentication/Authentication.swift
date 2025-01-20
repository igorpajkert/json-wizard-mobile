//
//  Authentication.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore

/// A class responsible for handling user authentication using Firebase.
@Observable
class Authentication {
    
    /// The currently signed-in user, or `nil` if no user is signed in.
    var user: User?
    
    /// A listener handle that observes changes to the Firebase authentication state.
    private var handle: AuthStateDidChangeListenerHandle?
    
    /// Initializes a new instance of `Authentication` and begins listening to authentication state changes.
    init() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.user = user
        }
    }
    
    /// Deinitializes the `Authentication`, removing the authentication state change listener.
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
    
    /// Sends a password reset email to the specified address using Firebase Authentication.
    ///
    /// - Parameter email: The email address for the user who needs to reset their password.
    /// - Throws: An error if the request to send the password reset email fails.
    func sendPasswordResetEmail(to email: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    /// Reauthenticates the current user with the given email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password associated with the email address.
    func reauthenticateUser(with email: String, password: String) async throws {
        guard let user = Auth.auth().currentUser else { throw AuthError.currentUserNotFound }
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    /// Updates the password of the currently authenticated user.
    ///
    /// - Parameter password: The new password to update the user's account with.
    func updatePassword(to password: String) async throws {
        guard let user = Auth.auth().currentUser else { throw AuthError.currentUserNotFound }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            user.updatePassword(to: password) { error in
                if let error = error as NSError? {
                    if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                        continuation.resume(throwing: AuthError.reauthenticationRequired)
                    } else {
                        continuation.resume(throwing: error)
                    }
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - Statics
    /// Indicates whether a currently signed in user is valid.
    static var isUserValid: Bool {
        // TODO: User Roles
        Auth.auth().currentUser != nil
    }
}
