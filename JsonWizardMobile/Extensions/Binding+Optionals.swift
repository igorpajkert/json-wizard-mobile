//
//  Binding+String?.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 06/01/2025.
//

import SwiftUI

extension Binding where Value == String? {
    func unwrapped(or defaultValue: String = "") -> Binding<String> {
        Binding<String>(
            get: { wrappedValue ?? defaultValue },
            set: { wrappedValue = $0 }
        )
    }
}

extension Binding where Value == Color? {
    func unwrapped(or defaultValue: Color = .clear) -> Binding<Color> {
        Binding<Color>(
            get: { wrappedValue ?? defaultValue },
            set: { wrappedValue = $0 }
        )
    }
}
