//
//  Answer.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation

/// A model that represents a single answer option in a question.
@Observable
final class Answer: Identifiable, Codable {
    
    /// A unique identifier for the answer.
    let id: Int
    /// The text content of this answer option.
    var answerText: String
    /// Indicates whether this answer is correct.
    var isCorrect: Bool
    /// The date and time when this answer was created.
    let dateCreated: Date
    /// Last modification date.
    var dateModified: Date
    
    /// Creates a new `Answer` instance.
    ///
    /// - Parameters:
    ///   - id: A unique numeric identifier.
    ///   - answerText: The text for this answer. Defaults to an empty string.
    ///   - isCorrect: Whether this answer is correct. Defaults to `false`.
    init(id: Int = Int.randomID(),
         answerText: String = "",
         isCorrect: Bool = false,
         dateCreated: Date = .now,
         dateModified: Date = .now
    ) {
        self.id = id
        self.answerText = answerText
        self.isCorrect = isCorrect
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
    
    // MARK: - Codable Conformance | Custom encoding & decoding
    /// Initializes the model by decoding from a `Decoder`.
    /// - Parameter decoder: The decoder containing the data to decode.
    /// - Throws: An error if decoding fails for any of the properties.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.answerText = try container.decode(String.self, forKey: .answerText)
        self.isCorrect = try container.decode(Bool.self, forKey: .isCorrect)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.dateModified = try container.decode(String.self, forKey: .dateModified).toDate()
    }
    
    /// Encodes the model into an `Encoder`.
    /// - Parameter encoder: The encoder to write the data into.
    /// - Throws: An error if encoding fails for any of the properties.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(answerText, forKey: .answerText)
        try container.encode(isCorrect, forKey: .isCorrect)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateModified.toString(), forKey: .dateModified)
    }
    
    /// Keys for encoding and decoding properties.
    private enum CodingKeys: String, CodingKey {
        case id, answerText, isCorrect, dateCreated, dateModified
    }
}

// MARK: Equatable Conformance
extension Answer: Equatable {
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        lhs.id == rhs.id &&
        lhs.answerText == rhs.answerText &&
        lhs.isCorrect == rhs.isCorrect &&
        lhs.dateCreated == rhs.dateCreated &&
        lhs.dateModified == rhs.dateModified
    }
}

// MARK: - Nameable Conformance
extension Answer: Nameable {
    var name: String { answerText }
}
