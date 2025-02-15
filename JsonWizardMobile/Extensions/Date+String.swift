//
//  Date+String.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 08/02/2025.
//

import Foundation

extension Date {
    
    /// Converts the Date instance to a formatted string.
    ///
    /// The date is formatted using the "dd-MM-yyyy HH:mm:ss" pattern.
    ///
    /// - Returns: A string representing the date in the specified format.
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return formatter.string(from: self)
    }
}

extension String {
    /// Converts the string to a Date instance.
    ///
    /// The string is parsed using the "dd-MM-yyyy HH:mm:ss" format. If the parsing fails,
    /// the current date (`Date.now`) is returned.
    ///
    /// - Returns: A Date object if the string can be parsed successfully; otherwise, the current date.
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return formatter.date(from: self) ?? Date.now
    }
}
