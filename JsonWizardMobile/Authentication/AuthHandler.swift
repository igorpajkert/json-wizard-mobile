//
//  AuthHandler.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore

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
            case .currentUserNotFound: return "No currently signed-in user was found. Please sign in first and continue."
            case .invalidUser: return "Currently signed-in user is not a valid developer account. Ask your administrator for assistance."
            case .reauthenticationRequired: return "This operation is sensitive and requires a recent sign-in. Please sign in first and try again."
            }
        }
    }
}
