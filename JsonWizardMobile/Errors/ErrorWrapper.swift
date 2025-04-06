//
//  ErrorWrapper.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import Foundation

/// A struct that wraps an `Error` with contextual guidance and an optional action.
struct ErrorWrapper: Identifiable {
    
    /// A unique identifier for this error wrapper instance.
    let id: UUID
    /// The underlying error being wrapped.
    let error: Error
    /// A user-friendly message or guidance on how to handle the error.
    let guidance: String
    /// Indicates whether this error can be dismissed by the user.
    let isDismissable: Bool
    /// An optional action to perform when the error is dismissed.
    ///
    /// If `dismissAction` is `nil`, no action is performed upon dismissal.
    let dismissAction: ErrorAction?
    
    /// Creates a new `ErrorWrapper` instance.
    init(id: UUID = UUID(),
         error: Error,
         guidance: String,
         isDismissable: Bool = true,
         dismissAction: ErrorAction? = nil) {
        self.id = id
        self.error = error
        self.guidance = guidance
        self.isDismissable = isDismissable
        self.dismissAction = dismissAction
    }
    
    /// An action that may be performed when dismissing an error.
    struct ErrorAction {
        /// A user‐friendly title describing the action.
        let title: String
        /// The closure that performs the action.
        let action: () -> Void
    }
}

extension ErrorWrapper {
    /// A collection of sample errors used for demonstration or testing purposes.
    enum SampleError: Error {
        case sample
    }
}
