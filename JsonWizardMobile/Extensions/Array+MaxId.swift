//
//  Array+MaxId.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import Foundation

extension Array where Element == Question {
    /// A computed property that returns the maximum `id` value among all elements of type `Question` in the array.
    ///
    /// This property uses the `max(by:)` method to find the element with the highest `id`. If the array is empty,
    /// the property returns `0` as a default value.
    ///
    /// - Returns: The highest `id` value in the array, or `0` if the array is empty.
    var maxId: Int { self.max(by: { $0.id < $1.id })?.id ?? 0 }
}

extension Array where Element == Category {
    /// A computed property that returns the maximum `id` value among all elements of type `Category` in the array.
    ///
    /// This property uses the `max(by:)` method to find the element with the highest `id`. If the array is empty,
    /// the property returns `0` as a default value.
    ///
    /// - Returns: The highest `id` value in the array, or `0` if the array is empty.
    var maxId: Int { self.max(by: { $0.id < $1.id })?.id ?? 0 }
}
