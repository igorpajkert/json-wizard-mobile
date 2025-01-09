//
//  Categories.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 09/01/2025.
//

import Foundation

/// A model class that encapsulates a collection of `Category` objects.
@Observable
final class Categories: Codable {
    
    /// An array of `Category` objects.
    var categories: [Category]
    
    /// Initializes the `Categories` model with an optional array of `Category` objects.
    /// - Parameter categories: An array of `Category` objects. Defaults to an empty array.
    init(categories: [Category] = []) {
        self.categories = categories
    }
    
    // MARK: - Codable Conformance | Custom encoding & decoding
    /// Decodes a `Categories` object from a decoder.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categories = try container.decode([Category].self, forKey: .categories)
    }
    
    /// Encodes a `Categories` object into an encoder.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categories, forKey: .categories)
    }
    
    /// Keys used to encode and decode `Categories` objects.
    private enum CodingKeys: String, CodingKey {
        case categories
    }
}
