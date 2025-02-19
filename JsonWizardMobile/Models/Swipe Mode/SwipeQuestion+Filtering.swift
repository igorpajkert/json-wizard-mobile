//
//  SwipeQuestion+Filtering.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/02/2025.
//

import Foundation

// MARK: Filtering
extension SwipeQuestion {
    /// Represents the filtering options available for `SwipeQuestion` instances.
    enum FilterOptions: String, CaseIterable, Identifiable, Nameable {
        case none
        case correct
        case incorrect
        
        var id: String { rawValue }
        
        /// A localized name for the filter option.
        var name: String {
            switch self {
            case .none:
                return String(localized: "filter_options_none")
            case .correct:
                return String(localized: "filter_options_correct")
            case .incorrect:
                return String(localized: "filter_options_incorrect")
            }
        }
    }
}
