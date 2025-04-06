//
//  SwipeQuestion.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/02/2025.
//

import Foundation

@Observable
final class SwipeQuestion: Identifiable, Codable {
    
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.isCorrect = try container.decode(Bool.self, forKey: .isCorrect)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.dateModified = try container.decode(Date.self, forKey: .dateModified)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(isCorrect, forKey: .isCorrect)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateModified, forKey: .dateModified)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, text, isCorrect, dateCreated, dateModified, editedBy
    }
}

extension SwipeQuestion: Nameable {
    var name: String { text }
}

extension SwipeQuestion: Equatable {
    static func == (lhs: SwipeQuestion, rhs: SwipeQuestion) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.isCorrect == rhs.isCorrect &&
        lhs.dateCreated == rhs.dateCreated &&
        lhs.dateModified == rhs.dateModified
    }
}

extension SwipeQuestion: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
