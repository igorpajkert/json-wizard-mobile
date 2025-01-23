//
//  Binding+String?.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 06/01/2025.
//

import SwiftUI

extension Binding where Value == String? {
    /// Returns a `Binding<String>` by replacing `nil` values with the given default.
    ///
    /// Use this method to avoid optional unwrapping when working with a `Binding<String?>`.
    /// If the underlying optional is `nil`, the binding’s `get` returns `defaultValue`,
    /// and `set` sets the wrapped value to the new non-optional value.
    ///
    /// - Parameter defaultValue: A fallback `String` value used whenever the wrapped
    ///   value is `nil`. Defaults to an empty string (`""`).
    /// - Returns: A non-optional `Binding<String>` that substitutes `defaultValue`
    ///   if the wrapped value is `nil`.
    func unwrapped(or defaultValue: String = "") -> Binding<String> {
        Binding<String>(
            get: { wrappedValue ?? defaultValue },
            set: { wrappedValue = $0 }
        )
    }
}

extension Binding where Value == Color? {
    /// Returns a `Binding<Color>` by replacing `nil` values with the given default.
    ///
    /// Use this method to avoid optional unwrapping when working with a `Binding<Color?>`.
    /// If the underlying optional is `nil`, the binding’s `get` returns `defaultValue`,
    /// and `set` sets the wrapped value to the new non-optional value.
    ///
    /// - Parameter defaultValue: A fallback `Color` value used whenever the wrapped
    ///   value is `nil`. Defaults to `.clear`.
    /// - Returns: A non-optional `Binding<Color>` that substitutes `defaultValue`
    ///   if the wrapped value is `nil`.
    func unwrapped(or defaultValue: Color = .accent) -> Binding<Color> {
        Binding<Color>(
            get: { wrappedValue ?? defaultValue },
            set: { wrappedValue = $0 }
        )
    }
}
