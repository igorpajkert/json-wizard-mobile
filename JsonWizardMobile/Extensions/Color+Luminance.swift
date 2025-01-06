//
//  Color+Luminance.swift
//  JsonWizardMobile
//
//  Created by Igor Pajkert on 27/12/2024.
//

import SwiftUI
import UIKit

extension Color {
    /// Computes the luminance of the color using the standard
    /// relative luminance formula for RGB.
    ///
    /// This value is derived based on the `red`, `green`, and `blue`
    /// components of the color, weighted according to human perception.
    ///
    /// - Returns: A `Double` in the range [0, 1], where higher values
    ///   indicate higher luminance.
    func luminance() -> Double {
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }
    
    /// Determines whether the color is considered light based on its luminance.
    ///
    /// - Returns: `true` if the luminance is higher than 0.5, `false` otherwise.
    func isLight() -> Bool {
        luminance() > 0.5
    }
    
    /// Chooses a text color (black or white) that has good contrast against this color.
    ///
    /// Useful for automatically picking a readable text color when the background color
    /// can vary. If `isLight()` is `true`, this returns `.black`, otherwise `.white`.
    ///
    /// - Returns: The contrast‐adapted `Color` for displaying text.
    func adaptedTextColor() -> Color {
        isLight() ? Color.black : Color.white
    }
}
