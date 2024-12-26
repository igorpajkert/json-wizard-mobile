//
//  Status.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation

enum Status: String, CaseIterable, Identifiable, Hashable, Codable {
    case done = "Done"
    case inProgress = "In Progress"
    case draft = "Draft"
    case needsRework = "Needs Rework"
    
    var name: String {
        rawValue
    }
    
    var id: String {
        name
    }
}
