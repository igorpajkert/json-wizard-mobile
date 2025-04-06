//
//  SwipeMode+Environment.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/03/2025.
//

import SwiftUI

extension EnvironmentValues {
    /// A `SwipeMode` object stored in the environment.
    @Entry var swipeMode = SwipeMode()
}

extension View {
    /// Injects the given `SwipeMode` instance into the SwiftUI environment.
    func swipeMode(_ swipeMode: SwipeMode) -> some View {
        environment(\.swipeMode, swipeMode)
    }
}
