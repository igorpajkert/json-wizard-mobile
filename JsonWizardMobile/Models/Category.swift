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
final class Category: Codable, Identifiable {
    
    /// A unique identifier for the category.
    let id: Int
    /// A short title or name for the category.
    var title: String
    /// An optional subtitle providing extra context about the category.
    var subtitle: String?
    /// A list of questions belonging to this category.
    var questions: [Question]
    /// The status of this category.
    var status: Status
    /// An optional color used to visually represent this category.
    var color: Color?
    /// The date and time when this category was created.
    let dateCreated: Date
    
    /// The total number of questions in this category.
    var questionsCount: Int { questions.count }
    
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
    init(id: Int,
         title: String = "",
         subtitle: String? = nil,
         questions: [Question] = [],
         status: Status = .draft,
         color: Color? = nil,
         dateCreated: Date = .now) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.questions = questions
        self.status = status
        self.color = color
        self.dateCreated = dateCreated
    }
}

// MARK: - Extension for Convenience
extension Category {
    /// A convenience property that ensures a non-optional `Color`.
    ///
    /// If the `color` property is `nil`, this returns a fallback `.accent` color.
    /// Use `unwrappedColor` to avoid optional checks when displaying or using
    /// a color for this category.
    var unwrappedColor: Color { color ?? .accent}
}

// MARK: - Equatable Conformance
extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}
