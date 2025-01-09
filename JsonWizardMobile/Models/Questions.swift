//
//  Questions.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 09/01/2025.
//

import Foundation

/// A model class that encapsulates a collection of `Question` objects.
@Observable
final class Questions: Codable {
    
    /// An array of `Question` objects.
    var questions: [Question]
    
    /// Initializes the `Questions` model with an optional array of `Question` objects.
    /// - Parameter questions: An array of `Question` objects. Defaults to an empty array.
    init(questions: [Question] = []) {
        self.questions = questions
    }
    
    // MARK: - Codable Conformance | Custom encoding & decoding
    /// Decodes a `Questions` object from a decoder.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.questions = try container.decode([Question].self, forKey: .questions)
    }
    
    /// Encodes a `Questions` object into an encoder.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(questions, forKey: .questions)
    }
    
    /// Keys used to encode and decode `Questions` objects.
    private enum CodingKeys: String, CodingKey {
        case questions
    }
}
