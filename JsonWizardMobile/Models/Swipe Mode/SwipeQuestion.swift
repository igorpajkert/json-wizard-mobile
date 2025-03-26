//
//  SwipeQuestion.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/02/2025.
//

import Foundation

struct SwipeQuestion: Identifiable, Equatable, Hashable, Codable {
    
    let id: Int
    var text: String {
        didSet {
            dateModified = .now
        }
    }
    var isCorrect: Bool {
        didSet {
            dateModified = .now
        }
    }
    let dateCreated: Date
    var dateModified: Date
    
    init(
        id: Int = Int.randomID(),
        text: String = "",
        isCorrect: Bool = false,
        dateCreated: Date = .now,
        dateModified: Date = .now
    ) {
        self.id = id
        self.text = text
        self.isCorrect = isCorrect
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}

extension SwipeQuestion: Nameable {
    var name: String { text }
}
