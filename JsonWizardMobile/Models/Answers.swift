//
//  Answers.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 19/01/2025.
//

import Foundation

/// A model class that encapsulates a collection of `Answer` objects.
@Observable
final class Answers: Codable {
    
    /// An array of `Answer` objects.
    var answers: [Answer]
    
    /// Initializes the `Answers` model with an optional array of `Answer` objects.
    /// - Parameter answers: An array of `Answer` objects. Defaults to an empty array.
    init(answers: [Answer] = []) {
        self.answers = answers
    }
    
    // MARK: - Codable Conformance | Custom encoding & decoding
    /// Decodes an instance of `Answers` from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: A `DecodingError` if decoding fails.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.answers = try container.decode([Answer].self, forKey: .answers)
    }
    
    /// Encodes this `Answers` instance into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An `EncodingError` if encoding fails.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.answers, forKey: .answers)
    }
    
    /// Coding keys used for encoding and decoding `Answers`.
    enum CodingKeys: CodingKey {
        case answers
    }
}
