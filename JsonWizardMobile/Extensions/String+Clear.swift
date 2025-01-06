//
//  String+Clear.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 04/01/2025.
//

import Foundation

extension String {
    /// Sets the string’s contents to an empty string.
    ///
    /// - Important: This is a mutating method, so it directly modifies
    ///   the existing string rather than returning a new one.
    ///
    /// - Remark: If you declare a string as a constant with `let`,
    ///   you won’t be able to call this method. Make sure the
    ///   string is declared as `var`.
    ///
    /// **Example:**
    /// ```swift
    /// var sampleText = "Hello, world!"
    /// sampleText.clear() // sampleText is now ""
    /// ```
    mutating func clear() {
        self = ""
    }
}
