//
//  Status.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import SwiftUI

/// A status type representing the various states of an item.
enum Status: String, CaseIterable, Identifiable, Hashable, Codable, Nameable {
    
    /// Final or completed state.
    case done = "Done"
    /// Currently in progress, not yet complete.
    case inProgress = "In Progress"
    /// In draft form, likely unfinished or pending review.
    case draft = "Draft"
    /// Requires further work or edits.
    case needsRework = "Needs Rework"
    
    /// A human-readable name for the status.
    ///
    /// Returns the raw string value of the enum case.
    var name: String {
        rawValue
    }
    
    /// The unique identifier for conformance to `Identifiable`.
    ///
    /// This returns the same string as `name` to uniquely identify each case.
    var id: String {
        name
    }
    
    /// A primary color associated with this status.
    var mainColor: Color {
        Color(rawValue)
    }
    
    /// An accent color that complements the `mainColor`.
    ///
    /// - Returns:
    ///     `.black` for the `.draft` status, `.white` for all other cases.
    var accentColor: Color {
        switch self {
        case .draft: return .black
        default: return .white
        }
    }
}
