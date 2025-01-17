//
//  Authentication+Environment.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 11/01/2025.
//

import SwiftUI

extension EnvironmentValues {
    /// An `Authentication` object stored in the environment.
    ///
    /// The default value is a new instance of `Authentication`. You can override
    /// this by calling `.auth(_:)` on a parent view to provide
    /// a custom instance of `Authentication`.
    @Entry var auth = Authentication()
}

extension View {
    /// Injects the given `Authentication` instance into the SwiftUI environment.
    ///
    /// - Parameter auth: The `Authentication` instance to be stored in
    ///   the environment.
    /// - Returns: A modified view that carries the given `Authentication` instance
    ///   in its environment.
    func auth(_ auth: Authentication) -> some View {
        environment(\.auth, auth)
    }
}
