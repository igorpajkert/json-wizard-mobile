//
//  Color+Codable.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI
import UIKit

extension Color: Codable {
    /// Encodes this SwiftUI `Color` into the given encoder.
    ///
    /// The color is converted to a `UIColor` in order to extract
    /// its `red`, `green`, `blue`, and `alpha` components. Those
    /// values are then stored under corresponding coding keys.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if any value fails to encode.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(alpha, forKey: .opacity)
    }
    
    /// Initializes a SwiftUI `Color` from the given decoder.
    ///
    /// Reads `red`, `green`, `blue`, and `opacity` values from the
    /// decoder and constructs a new `Color` instance with those
    /// component values.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if any value fails to decode.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let red = try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue = try container.decode(CGFloat.self, forKey: .blue)
        let opacity = try container.decode(CGFloat.self, forKey: .opacity)
        
        self = Color(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    /// The coding keys used for storing and retrieving the color components.
    private enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
}
