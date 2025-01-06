//
//  DataStore+Environment.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 02/01/2025.
//

import SwiftUI

extension EnvironmentValues {
    /// A `DataStore` object stored in the environment.
    ///
    /// The default value is a new instance of `DataStore`. You can override
    /// this by calling `.dataStore(_:)` on a parent view to provide
    /// a custom instance of `DataStore`.
    @Entry var store = DataStore()
}

extension View {
    /// Injects the given `DataStore` instance into the SwiftUI environment.
    ///
    /// - Parameter store: The `DataStore` instance to be stored in
    ///   the environment.
    /// - Returns: A modified view that carries the given `DataStore` instance
    ///   in its environment.
    func dataStore(_ store: DataStore) -> some View {
        environment(\.store, store)
    }
}
