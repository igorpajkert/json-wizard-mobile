//
//  Category.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 24/12/2024.
//

import Foundation
import SwiftUI

/// A model that represents a question category.
@Observable
final class Category: Identifiable, Codable {
    
    /// A unique identifier for the category.
    let id: Int
    /// A short title or name for the category.
    var title: String
    /// An optional subtitle providing extra context about the category.
    var subtitle: String?
    /// A list of questions belonging to this category.
    var questionIDs: [Int]
    /// The status of this category.
    var status: Status
    /// An optional color used to visually represent this category.
    var color: Color?
    /// The date and time when this category was created.
    let dateCreated: Date
    /// Last modification date.
    var dateModified: Date
    
    /// The total number of questions in this category.
    var questionsCount: Int { questionIDs.count }
    
    /// Creates a new `Category` instance.
    ///
    /// - Parameters:
    ///   - id: A unique numeric identifier.
    ///   - title: The name of the category. Defaults to an empty string.
    ///   - subtitle: An optional subtitle for additional context. Defaults to `nil`.
    ///   - questions: The list of questions in this category. Defaults to an empty array.
    ///   - status: The state of this category. Defaults to `.draft`.
    ///   - color: An optional color representing this category. Defaults to `nil`.
    ///   - dateCreated: A date indicating when this category was created.
    ///     Defaults to the current time (`.now`).
    init(id: Int = Int.randomID(),
         title: String = "",
         subtitle: String? = nil,
         questions: [Question] = [],
         status: Status = .draft,
         color: Color? = nil,
         dateCreated: Date = .now,
         dateModified: Date = .now
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.questionIDs = questions.map { $0.id }
        self.status = status
        self.color = color
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
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.questionIDs = try container.decode([Int].self, forKey: .questionIDs)
        self.status = try container.decode(Status.self, forKey: .status)
        self.color = try container.decodeIfPresent(Color.self, forKey: .color)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.dateModified = try container.decode(String.self, forKey: .dateModified).toDate()
    }
    
    /// Encodes the model into an `Encoder`.
    /// - Parameter encoder: The encoder to write the data into.
    /// - Throws: An error if encoding fails for any of the properties.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(subtitle, forKey: .subtitle)
        try container.encode(questionIDs, forKey: .questionIDs)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateModified.toString(), forKey: .dateModified)
        try container.encode(questionsCount, forKey: .questionsCount)
    }
    
    /// Keys for encoding and decoding properties.
    private enum CodingKeys: String, CodingKey {
        case id, title, subtitle, questionIDs, status, color, dateCreated, dateModified, questionsCount
    }
}

// MARK: - Extension for Convenience
extension Category {
    /// A convenience property that ensures a non-optional `Color`.
    ///
    /// If the `color` property is `nil`, this returns a fallback `.accent` color.
    /// Use `unwrappedColor` to avoid optional checks when displaying or using
    /// a color for this category.
    var unwrappedColor: Color { color ?? .accent }
}

// MARK: - Equatable Conformance
extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}

// MARK: - Nameable Conformance
extension Category: Nameable {
    var name: String { title }
}

// MARK: - Hashable Conformance
extension Category: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
