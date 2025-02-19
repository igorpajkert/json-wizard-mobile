//
//  SwipeQuestion+Sorting.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/02/2025.
//

import Foundation

// MARK: Sorting
extension SwipeQuestion {
    /// Represents the sorting options available for `SwipeQuestion` instances.
    enum SortOptions: String, CaseIterable, Identifiable, Nameable {
        case recent
        case alphabetical
        case correct
        case incorrect
        
        var id: String { rawValue }
        
        /// A localized name for the sorting option.
        var name: String {
            switch self {
            case .recent:
                return String(localized: "sort_options_recent")
            case .alphabetical:
                return String(localized: "sort_options_alphabetical")
            case .correct:
                return String(localized: "sort_options_correct")
            case .incorrect:
                return String(localized: "sort_options_incorrect")
            }
        }
    }
}
