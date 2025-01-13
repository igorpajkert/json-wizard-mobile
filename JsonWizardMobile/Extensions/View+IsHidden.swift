//
//  View+IsHidden.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 12/01/2025.
//

import SwiftUI

extension View {
    /// A view modifier that conditionally hides a view based on a Boolean parameter.
    ///
    /// - Parameter isHidden: A Boolean indicating whether the view should be hidden (`true`) or shown (`false`).
    /// - Returns: A modified view that is hidden if `isHidden` is `true`; otherwise, the original view.
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}
