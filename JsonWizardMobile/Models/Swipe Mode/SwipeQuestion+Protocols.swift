//
//  SwipeQuestion+Protocols.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/02/2025.
//

import Foundation

// MARK: Equatable Conformance
extension SwipeQuestion: Equatable {
    static func == (lhs: SwipeQuestion, rhs: SwipeQuestion) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.isCorrect == rhs.isCorrect &&
        lhs.dateCreated == rhs.dateCreated &&
        lhs.dateModified == rhs.dateModified
    }
}

// MARK: Nameable Conformance
extension SwipeQuestion: Nameable {
    var name: String { text }
}

// MARK: Hashable Conformance
extension SwipeQuestion: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
