//
//  Array+Append.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 20/01/2025.
//

import Foundation

extension Array {
    mutating func appendIfNotContains(_ newElement: Element) where Element: Equatable {
        if !contains(newElement) {
            append(newElement)
        }
    }
}
