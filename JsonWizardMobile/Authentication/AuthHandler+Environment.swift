//
//  AuthHandler+Environment.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import SwiftUI

extension EnvironmentValues {
    /// An `AuthHandler` object stored in the environment.
    ///
    /// The default value is a new instance of `AuthHandler`. You can override
    /// this by calling `.AuthHandler(_:)` on a parent view to provide
    /// a custom instance of `AuthHandler`.
    @Entry var authHandler = AuthHandler()
}

extension View {
    /// Injects the given `AuthHandler` instance into the SwiftUI environment.
    ///
    /// - Parameter handler: The `AuthHandler` instance to be stored in
    ///   the environment.
    /// - Returns: A modified view that carries the given `AuthHandler` instance
    ///   in its environment.
    func authHandler(_ handler: AuthHandler) -> some View {
        environment(\.authHandler, handler)
    }
}
