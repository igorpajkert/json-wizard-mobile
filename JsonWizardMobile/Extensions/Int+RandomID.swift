//
//  Int+RandomID.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 23/01/2025.
//

import Foundation

extension Int {
    /// Generates a pseudo-unique integer ID using the current system uptime in nanoseconds plus a random offset.
    ///
    /// - Returns: A random integer combining the system uptime in nanoseconds and a random value in the range 0 to 100.
    static func randomID() -> Int {
        let timestamp = DispatchTime.now().uptimeNanoseconds
        let number = Int.random(in: 0...100)
        return Int(timestamp) + number
    }
}
