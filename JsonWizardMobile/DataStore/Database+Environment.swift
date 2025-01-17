//
//  Database+Environment.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 16/01/2025.
//

import SwiftUI

extension EnvironmentValues {
    /// A `DatabaseController` object stored in the environment.
    ///
    /// The default value is a new instance of `DatabaseController`. You can override
    /// this by calling `.database(_:)` on a parent view to provide
    /// a custom instance of `DatabaseController`.
    @Entry var database = DatabaseController()
}

extension View {
    /// Injects the given `DatabaseController` instance into the SwiftUI environment.
    ///
    /// - Parameter database: The `DatabaseController` instance to be stored in
    ///   the environment.
    /// - Returns: A modified view that carries the given `DatabaseController` instance
    ///   in its environment.
    func database(_ database: DatabaseController) -> some View {
        environment(\.database, database)
    }
}
